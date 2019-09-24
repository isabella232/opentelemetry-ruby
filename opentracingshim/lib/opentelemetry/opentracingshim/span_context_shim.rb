# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module OpenTracingShim
    # A SpanContextShim provides a means of treating an OpenTelemetry::Trace::SpanContext
    # as an OpenTracing::SpanContext
    class SpanContextShim
      attr_reader :context

      # Returns a new {SpanContextShim}
      #
      # @param [SpanContext] context the OpenTelemetry SpanContext to shim
      # @return [SpanContextShim]
      def initialize(context)
        @context = context
      end

      def trace_id
        context.trace_id
      end

      def span_id
        context.span_id
      end

      # Currently unimplemented
      def baggage
        nil
      end
    end
  end
end