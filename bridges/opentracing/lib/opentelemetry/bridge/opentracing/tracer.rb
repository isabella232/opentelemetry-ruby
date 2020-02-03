# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Bridge
    module OpenTracing
      # Tracer provides a means of referencing
      # an OpenTelemetry::Tracer as a OpenTracing::Tracer
      class Tracer
        attr_reader :tracer

        def initialize(tracer)
          @tracer = tracer
          @tracer_factory = OpenTelemetry::Trace::TracerFactory.new
        end

        def active_span
          @tracer.current_span
        end

        def start_active_span(operation_name,
                              child_of: nil,
                              references: nil,
                              start_time: Time.now,
                              tags: nil,
                              ignore_active_scope: false,
                              finish_on_close: true,
                              &block)
          span = @tracer.start_span(operation_name,
                                    with_parent: child_of,
                                    attributes: tags,
                                    links: references,
                                    start_timestamp: start_time)
          scope = Scope.new(ScopeManager.new, span, finish_on_close)
          if block_given?
            yield scope
            return @tracer.with_span(span, &block)
          end

          scope
        end

        def start_span(operation_name,
                       child_of: nil,
                       references: nil,
                       start_time: Time.now,
                       tags: nil,
                       ignore_active_scope: false,
                       &block)
          span = @tracer.start_span(operation_name,
                                    with_parent: child_of,
                                    attributes: tags,
                                    links: references,
                                    start_timestamp: start_time)
          if block_given?
            yield span
            return @tracer.with_span(span, &block)
          end
          span
        end

        def inject(span_context, format, carrier)
          case format
          when ::OpenTracing::FORMAT_TEXT_MAP
            context = span_context.context
            @tracer_factory.http_text_format.inject(context, carrier) { |c, k, v| return c, k, v }
          when ::OpenTracing::FORMAT_RACK
            context = span_context.context
            @tracer_factory.rack_http_text_format.inject(context, carrier) { |c, k, v| return c, k, v }
          when ::OpenTracing::FORMAT_BINARY
            @tracer_factory.binary_format.to_bytes(span_context.context)
          else
            warn 'Unknown inject format'
          end
        end

        def extract(format, carrier)
          case format
          when ::OpenTracing::FORMAT_TEXT_MAP
            @tracer_factory.http_text_format.extract(carrier)
          when ::OpenTracing::FORMAT_RACK
            @tracer_factory.rack_http_text_format.extract(carrier)
          when ::OpenTracing::FORMAT_BINARY
            @tracer_factory.binary_format.from_bytes(carrier)
          else
            warn 'Unknown extract format'
          end
        end
      end
    end
  end
end