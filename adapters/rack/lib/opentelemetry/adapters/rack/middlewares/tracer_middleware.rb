# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'opentelemetry/trace/status'

require_relative '../util/queue_time'

module OpenTelemetry
  module Adapters
    module Rack
      module Middlewares
        # TracerMiddleware propagates context and instruments Rack requests
        # by way of its middleware system
        class TracerMiddleware # rubocop:disable Metrics/ClassLength
          class << self
            def allowed_rack_request_headers
              @allowed_rack_request_headers ||= Array(config[:allowed_request_headers]).each_with_object({}) do |header, memo|
                memo["HTTP_#{header.to_s.upcase.gsub(/[-\s]/, '_')}"] = build_attribute_name('http.request.headers.', header)
              end
            end

            def allowed_response_headers
              @allowed_response_headers ||= Array(config[:allowed_response_headers]).each_with_object({}) do |header, memo|
                memo[header] = build_attribute_name('http.response.headers.', header)
                memo[header.to_s.upcase] = build_attribute_name('http.response.headers.', header)
              end
            end

            def build_attribute_name(prefix, suffix)
              prefix + suffix.to_s.downcase.gsub(/[-\s]/, '_')
            end

            def config
              Rack::Adapter.instance.config
            end

            private

            def clear_cached_config
              @allowed_rack_request_headers = nil
              @allowed_response_headers = nil
            end
          end

          EMPTY_HASH = {}.freeze

          def initialize(app)
            @app = app
          end

          def call(env)
            original_env = env.dup
            extracted_context = OpenTelemetry.propagation.http.extract(env)
            frontend_context = create_frontend_span(env, extracted_context)

            # restore extracted context in this process:
            OpenTelemetry::Context.with_current(frontend_context || extracted_context) do
              request_span_name = create_request_span_name(env['REQUEST_URI'] || original_env['PATH_INFO'])
              request_span_kind = frontend_context.nil? ? :server : :internal
              tracer.in_span(request_span_name,
                             attributes: request_span_attributes(env: env),
                             kind: request_span_kind) do |request_span|
                @app.call(env).tap do |status, headers, response|
                  set_attributes_after_request(request_span, status, headers, response)
                end
              end
            end
          ensure
            finish_span(frontend_context)
          end

          private

          # return Context with the frontend span as the current span
          def create_frontend_span(env, extracted_context)
            request_start_time = OpenTelemetry::Adapters::Rack::Util::QueueTime.get_request_start(env)

            return unless config[:record_frontend_span] && !request_start_time.nil?

            span = tracer.start_span('http_server.proxy',
                                     with_parent_context: extracted_context,
                                     attributes: {
                                       'component' => 'http',
                                       'start_time' => request_start_time.to_f
                                     },
                                     kind: :server)

            extracted_context.set_value(current_span_key, span)
          end

          def finish_span(context)
            context[current_span_key]&.finish if context
          end

          def current_span_key
            OpenTelemetry::Trace::Propagation::ContextKeys.current_span_key
          end

          def tracer
            OpenTelemetry::Adapters::Rack::Adapter.instance.tracer
          end

          def request_span_attributes(env:)
            {
              'component' => 'http',
              'http.method' => env['REQUEST_METHOD'],
              'http.host' => env['HTTP_HOST'] || 'unknown',
              'http.scheme' => env['rack.url_scheme'],
              'http.target' => fullpath(env)
            }.merge(allowed_request_headers(env))
          end

          # e.g., "/webshop/articles/4?s=1":
          def fullpath(env)
            query_string = env['QUERY_STRING']
            path = env['SCRIPT_NAME'] + env['PATH_INFO']

            query_string.empty? ? path : "#{path}?#{query_string}"
          end

          # https://github.com/open-telemetry/opentelemetry-specification/blob/master/specification/data-http.md#name
          #
          # recommendation: span.name(s) should be low-cardinality (e.g.,
          # strip off query param value, keep param name)
          #
          # see http://github.com/open-telemetry/opentelemetry-specification/pull/416/files
          def create_request_span_name(request_uri_or_path_info)
            # NOTE: dd-trace-rb has implemented 'quantization' (which lowers url cardinality)
            #       see Datadog::Quantization::HTTP.url

            if (implementation = config[:url_quantization])
              implementation.call(request_uri_or_path_info)
            else
              request_uri_or_path_info
            end
          end

          def set_attributes_after_request(span, status, headers, _response)
            span.status = OpenTelemetry::Trace::Status.http_to_status(status)
            span.set_attribute('http.status_code', status)

            # NOTE: if data is available, it would be good to do this:
            # set_attribute('http.route', ...
            # e.g., "/users/:userID?
            span.set_attribute('http.status_text', ::Rack::Utils::HTTP_STATUS_CODES[status])

            allowed_response_headers(headers).each { |k, v| span.set_attribute(k, v) }
          end

          def allowed_request_headers(env)
            return EMPTY_HASH if self.class.allowed_rack_request_headers.empty?

            {}.tap do |result|
              self.class.allowed_rack_request_headers.each do |key, value|
                result[value] = env[key] if env.key?(key)
              end
            end
          end

          def allowed_response_headers(headers)
            return EMPTY_HASH if headers.nil?
            return EMPTY_HASH if self.class.allowed_response_headers.empty?

            {}.tap do |result|
              self.class.allowed_response_headers.each do |key, value|
                if headers.key?(key)
                  result[value] = headers[key]
                else
                  # do case-insensitive match:
                  headers.each do |k, v|
                    if k.upcase == key
                      result[value] = v
                      break
                    end
                  end
                end
              end
            end
          end

          def config
            Rack::Adapter.instance.config
          end
        end
      end
    end
  end
end
