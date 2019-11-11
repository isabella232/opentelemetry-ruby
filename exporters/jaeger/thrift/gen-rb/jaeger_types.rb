#
# Autogenerated by Thrift Compiler (0.12.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'

module OpenTelemetry
  module Exporters
    module Jaeger
      module Thrift
        module TagType
          STRING = 0
          DOUBLE = 1
          BOOL = 2
          LONG = 3
          BINARY = 4
          VALUE_MAP = {0 => "STRING", 1 => "DOUBLE", 2 => "BOOL", 3 => "LONG", 4 => "BINARY"}
          VALID_VALUES = Set.new([STRING, DOUBLE, BOOL, LONG, BINARY]).freeze
        end

        module SpanRefType
          CHILD_OF = 0
          FOLLOWS_FROM = 1
          VALUE_MAP = {0 => "CHILD_OF", 1 => "FOLLOWS_FROM"}
          VALID_VALUES = Set.new([CHILD_OF, FOLLOWS_FROM]).freeze
        end

        class Tag; end

        class Log; end

        class SpanRef; end

        class Span; end

        class Process; end

        class Batch; end

        class BatchSubmitResponse; end

        class Tag
          include ::Thrift::Struct, ::Thrift::Struct_Union
          KEY = 1
          VTYPE = 2
          VSTR = 3
          VDOUBLE = 4
          VBOOL = 5
          VLONG = 6
          VBINARY = 7

          FIELDS = {
            KEY => {:type => ::Thrift::Types::STRING, :name => 'key'},
            VTYPE => {:type => ::Thrift::Types::I32, :name => 'vType', :enum_class => ::OpenTelemetry::Exporters::Jaeger::Thrift::TagType},
            VSTR => {:type => ::Thrift::Types::STRING, :name => 'vStr', :optional => true},
            VDOUBLE => {:type => ::Thrift::Types::DOUBLE, :name => 'vDouble', :optional => true},
            VBOOL => {:type => ::Thrift::Types::BOOL, :name => 'vBool', :optional => true},
            VLONG => {:type => ::Thrift::Types::I64, :name => 'vLong', :optional => true},
            VBINARY => {:type => ::Thrift::Types::STRING, :name => 'vBinary', :binary => true, :optional => true}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field key is unset!') unless @key
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field vType is unset!') unless @vType
            unless @vType.nil? || ::OpenTelemetry::Exporters::Jaeger::Thrift::TagType::VALID_VALUES.include?(@vType)
              raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field vType!')
            end
          end

          ::Thrift::Struct.generate_accessors self
        end

        class Log
          include ::Thrift::Struct, ::Thrift::Struct_Union
          TIMESTAMP = 1
          FIELDS = 2

          FIELDS = {
            TIMESTAMP => {:type => ::Thrift::Types::I64, :name => 'timestamp'},
            FIELDS => {:type => ::Thrift::Types::LIST, :name => 'fields', :element => {:type => ::Thrift::Types::STRUCT, :class => ::OpenTelemetry::Exporters::Jaeger::Thrift::Tag}}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field timestamp is unset!') unless @timestamp
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field fields is unset!') unless @fields
          end

          ::Thrift::Struct.generate_accessors self
        end

        class SpanRef
          include ::Thrift::Struct, ::Thrift::Struct_Union
          REFTYPE = 1
          TRACEIDLOW = 2
          TRACEIDHIGH = 3
          SPANID = 4

          FIELDS = {
            REFTYPE => {:type => ::Thrift::Types::I32, :name => 'refType', :enum_class => ::OpenTelemetry::Exporters::Jaeger::Thrift::SpanRefType},
            TRACEIDLOW => {:type => ::Thrift::Types::I64, :name => 'traceIdLow'},
            TRACEIDHIGH => {:type => ::Thrift::Types::I64, :name => 'traceIdHigh'},
            SPANID => {:type => ::Thrift::Types::I64, :name => 'spanId'}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field refType is unset!') unless @refType
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field traceIdLow is unset!') unless @traceIdLow
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field traceIdHigh is unset!') unless @traceIdHigh
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field spanId is unset!') unless @spanId
            unless @refType.nil? || ::OpenTelemetry::Exporters::Jaeger::Thrift::SpanRefType::VALID_VALUES.include?(@refType)
              raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field refType!')
            end
          end

          ::Thrift::Struct.generate_accessors self
        end

        class Span
          include ::Thrift::Struct, ::Thrift::Struct_Union
          TRACEIDLOW = 1
          TRACEIDHIGH = 2
          SPANID = 3
          PARENTSPANID = 4
          OPERATIONNAME = 5
          REFERENCES = 6
          FLAGS = 7
          STARTTIME = 8
          DURATION = 9
          TAGS = 10
          LOGS = 11

          FIELDS = {
            TRACEIDLOW => {:type => ::Thrift::Types::I64, :name => 'traceIdLow'},
            TRACEIDHIGH => {:type => ::Thrift::Types::I64, :name => 'traceIdHigh'},
            SPANID => {:type => ::Thrift::Types::I64, :name => 'spanId'},
            PARENTSPANID => {:type => ::Thrift::Types::I64, :name => 'parentSpanId'},
            OPERATIONNAME => {:type => ::Thrift::Types::STRING, :name => 'operationName'},
            REFERENCES => {:type => ::Thrift::Types::LIST, :name => 'references', :element => {:type => ::Thrift::Types::STRUCT, :class => ::OpenTelemetry::Exporters::Jaeger::Thrift::SpanRef}, :optional => true},
            FLAGS => {:type => ::Thrift::Types::I32, :name => 'flags'},
            STARTTIME => {:type => ::Thrift::Types::I64, :name => 'startTime'},
            DURATION => {:type => ::Thrift::Types::I64, :name => 'duration'},
            TAGS => {:type => ::Thrift::Types::LIST, :name => 'tags', :element => {:type => ::Thrift::Types::STRUCT, :class => ::OpenTelemetry::Exporters::Jaeger::Thrift::Tag}, :optional => true},
            LOGS => {:type => ::Thrift::Types::LIST, :name => 'logs', :element => {:type => ::Thrift::Types::STRUCT, :class => ::OpenTelemetry::Exporters::Jaeger::Thrift::Log}, :optional => true}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field traceIdLow is unset!') unless @traceIdLow
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field traceIdHigh is unset!') unless @traceIdHigh
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field spanId is unset!') unless @spanId
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field parentSpanId is unset!') unless @parentSpanId
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field operationName is unset!') unless @operationName
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field flags is unset!') unless @flags
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field startTime is unset!') unless @startTime
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field duration is unset!') unless @duration
          end

          ::Thrift::Struct.generate_accessors self
        end

        class Process
          include ::Thrift::Struct, ::Thrift::Struct_Union
          SERVICENAME = 1
          TAGS = 2

          FIELDS = {
            SERVICENAME => {:type => ::Thrift::Types::STRING, :name => 'serviceName'},
            TAGS => {:type => ::Thrift::Types::LIST, :name => 'tags', :element => {:type => ::Thrift::Types::STRUCT, :class => ::OpenTelemetry::Exporters::Jaeger::Thrift::Tag}, :optional => true}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field serviceName is unset!') unless @serviceName
          end

          ::Thrift::Struct.generate_accessors self
        end

        class Batch
          include ::Thrift::Struct, ::Thrift::Struct_Union
          PROCESS = 1
          SPANS = 2

          FIELDS = {
            PROCESS => {:type => ::Thrift::Types::STRUCT, :name => 'process', :class => ::OpenTelemetry::Exporters::Jaeger::Thrift::Process},
            SPANS => {:type => ::Thrift::Types::LIST, :name => 'spans', :element => {:type => ::Thrift::Types::STRUCT, :class => ::OpenTelemetry::Exporters::Jaeger::Thrift::Span}}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field process is unset!') unless @process
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field spans is unset!') unless @spans
          end

          ::Thrift::Struct.generate_accessors self
        end

        class BatchSubmitResponse
          include ::Thrift::Struct, ::Thrift::Struct_Union
          OK = 1

          FIELDS = {
            OK => {:type => ::Thrift::Types::BOOL, :name => 'ok'}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field ok is unset!') if @ok.nil?
          end

          ::Thrift::Struct.generate_accessors self
        end

      end
    end
  end
end
