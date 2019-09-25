# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

describe OpenTelemetry::OpenTracingShim::ScopeShim do
  let(:mock_tracer) { Minitest::Mock.new }
  let(:scope_shim) { OpenTelemetry::OpenTracingShim::ScopeShim.new mock_tracer }
  describe '#span' do
    it 'gets the current span' do
      mock_tracer.expect(:current_span, 'an_active_span')
      as = scope_shim.span
      as.must_equal 'an_active_span'
      mock_tracer.verify
    end
  end

  describe '#close' do
    it 'calls finish on the tracers current span' do
      mock_span = Minitest::Mock.new
      mock_tracer.expect(:current_span, mock_span)
      mock_span.expect(:finish, nil)
      scope_shim.close
      mock_tracer.verify
      mock_span.verify
    end
  end
end
