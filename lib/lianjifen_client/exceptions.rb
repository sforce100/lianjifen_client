module LianjifenClient
  module Exceptions
    class ExceptionBase < StandardError
      attr_accessor :custom_code, :result
      def initialize(code: nil, data: nil, message: nil)
        @custom_code = code
        @result = data
        _message = message || "系统错误"
        super("#{_message}")
      end
    end

    class ServerLogicError < ExceptionBase
    end

  end
end