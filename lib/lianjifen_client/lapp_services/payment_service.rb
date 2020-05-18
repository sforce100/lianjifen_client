module LianjifenClient
  module LappServices
    class LianjifenService < LianjifenBaseService
      include HTTParty

      attr_accessor :service_error

      def base_uri
        "#{LianjifenClient.config["lianjifen"]["api_host"]}/yunjiafen/payment/api"
      end

      def generate_order(amount: 0, userId: nil, lastPayTime: nil, merchantPayable: nil, orderType: nil, outOrderId: nil, payResultCallbackUrl: nil, remark: nil)
        sign_data = {
          amount: amount,
          lastPayTime: lastPayTime,
          merchantPayable: merchantPayable,
          orderType: orderType,
          outOrderId: outOrderId,
          payResultCallbackUrl: payResultCallbackUrl,
          remark: remark,
          userId: userId
        }.delete_if { |key, value| value.blank? }
        result = JSON.parse(self.class.post(
          "#{base_uri}/v1/generateOrder?#{lianjifen_lapp_sign(sign_data).to_query}",
          body: sign_data.to_json,
          headers: { "Content-Type" => "application/json" },
        ).body)
        process_result(result)
      end

    end
  end
end