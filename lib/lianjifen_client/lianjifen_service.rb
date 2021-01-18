module LianjifenClient
  class LianjifenService < LianjifenBaseService
    include HTTParty

    def base_uri
      "#{LianjifenClient.config["lianjifen"]["api_host"]}/yunjiafen/open/api"
    end

    # 同步实名信息
    def ctf_sync(phone_number, id_card, name)
      sign_data = {
        phoneNumber: phone_number,
        idCard: id_card,
        name: name,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/merchant/user?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 商户创建用户
    def create_user(phone_number)
      sign_data = {
        phoneNumber: phone_number,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/merchant/user?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 主账号 积分交易-转账
    def merchant_transfor(point_symbol, phone_number, amount, mark = "")
      sign_data = {
        toId: phone_number,
        symbol: point_symbol,
        mark: mark,
        amount: amount,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/merchant/transfer?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 子账号 积分交易-转账
    def sub_merchant_transfor(sub_uuid, point_symbol, phone_number, amount, mark = "")
      sign_data = {
        toId: phone_number,
        symbol: point_symbol,
        mark: mark,
        amount: amount,
        subUuid: sub_uuid,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v2/merchant/transfer?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 积分交易-消费
    def merchant_consume(phone_number, amount, mark = "")
      sign_data = {
        toId: phone_number,
        mark: mark,
        amount: amount,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/merchant/consume?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 消费退款（消费退款）回收账户->个人账号
    def refund(txid, mark = "")
      sign_data = {
        transactionId: txid,
        mark: mark,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/merchant/refund?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 获取所有积分类型
    def point
      sign_data = {}
      result = JSON.parse(self.class.get(
        "#{base_uri}/v1/point",
        query: lianjifen_sign(sign_data),
      ).body)
      process_result(result)
    end

    # 获取用户所有积分余额
    # {
    #   "name": "ONE积分",
    #   "balance": "13700.00",
    #   "symbol": "jifenone",
    #   "orgName": "广州佰希区块链科技有限公司",
    #   "uuid": "9a2f24ca05d34d4dbc83d7cc6abc0a8a"
    # }
    def user_points(phone)
      sign_data = {
        phoneNumber: phone,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/user/types?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 查询用户积分
    # {
    #   "balance":123,
    #   "symbolName":"MT",
    #   "symbolIcon":"http://icons.iconarchive.com/icons/marcus-roberto/google-play/512/Google-Chrome-icon.png"
    # }
    def user_point(phone)
      sign_data = {
        phoneNumber: phone,
        create: true,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/user/balance?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 交易明细
    def transfor_info(id)
      sign_data = {}
      result = JSON.parse(self.class.get(
        "#{base_uri}/v1/merchant/transfer/#{id}",
        query: lianjifen_sign(sign_data),
      ).body)
      process_result(result)
    end

    # 积分明细
    def transaction_list(phone, symbol, page, size = 15)
      sign_data = {
        phoneNumber: phone,
        symbol: symbol,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/user/list/transaction?#{lianjifen_sign(sign_data).to_query}&page=#{page}&size=#{size}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 退分操作（个人账号->退分子账号）
    def common_points_refund(uuid, transaction_id)
      sign_data = {
        transactionId: transaction_id,
        accountUuid: uuid,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/merchant/billRefundToAccount?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 退分操作(购分退款)（个人账号->退分子账号）
    def points_refund(transaction_id)
      sign_data = {
        transactionId: transaction_id,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/merchant/billRefund?#{lianjifen_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 查询是否能退分(购分退款)（个人账号->退分子账号）
    def points_can_refund(transaction_id)
      sign_data = {
        transactionId: transaction_id,
      }
      query_hash = lianjifen_sign(sign_data)
      result = JSON.parse(self.class.get(
        "#{base_uri}/v1/merchant/canRefund?#{sign_data.to_query}",
        query: query_hash,
      ).body)
      process_result(result)
    end

    # 生成授权登录URL
    def generate_auth_url(phone_number, redirect_url = nil)
      request_data = {
        lappKey: LianjifenClient.config["lianjifen_app"]["app_key"],
        phoneNumber: phone_number,
      }
      if redirect_url.present?
        request_data[:redirectUrl] = redirect_url
      end
      sign_data = SignUtil.generate_common_sign_data("lianjifen", request_data)
      if redirect_url.present?
        sign_data[:redirectUrl] = URI.encode(redirect_url)
      end
      "#{LianjifenClient.config["lianjifen"]["api_host"]}/yunjiafen/open/api/v1/strategyApp/authPage?#{sign_data.to_query}"
    end

     # 生成积分商城授权登录URL
    def generate_auth_points_shop_url(phone_number, user_no)
      request_data = {
        lappKey: Settings.lianjifen_app.app_key,
        phoneNumber: phone_number,
        outUserNo: user_no,
        type: 'MALL'
      }
      sign_data = SignUtil.generate_common_sign_data("lianjifen", request_data)
      "#{LianjifenClient.config["lianjifen"]["api_host"]}/yunjiafen/consumer/user/auth/api/v1/redirectExchange?#{sign_data.to_query}"
    end

    # 生成重置支付密码URL
    # https://doc.xpayai.com/index.php?s=/17&page_id=1265
    def generate_resetpw_url(token, redirect_url = nil)
      request_data = {
        lianToken: token,
      }
      if redirect_url.present?
        request_data[:redirectUrl] = redirect_url
      end
      # sign_data = SignUtil.generate_common_sign_data("lianjifen", request_data)
      sign_data = SignUtil.generate_lapp_sign_data("lianjifen_app", request_data)
      if redirect_url.present?
        sign_data[:redirectUrl] = URI.encode(redirect_url)
      end
      "#{LianjifenClient.config["lianjifen"]["api_host"]}/yunjiafen/open/api/v1/strategyApp/setPassword?#{sign_data.to_query}"
    end

    # 生成预支付订单
    def perpay_order(order_no: nil, amount: 0, remark: "", token: "", notify_url: "")
      sign_data = {
        outOrderId: order_no,
        amount: amount,
        remark: remark,
        lianToken: token,
      }
      if notify_url.present?
        sign_data[:payResultCallbackUrl] = notify_url
      end
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/sa/transaction/generateOrder?#{lianjifen_lapp_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    # 生成预支付订单
    def lapp_refund(txid, remark = "")
      sign_data = {
        transactionId: txid,
        remark: remark,
      }
      result = JSON.parse(self.class.post(
        "#{base_uri}/v1/sa/transaction/refund?#{lianjifen_lapp_sign(sign_data).to_query}",
        body: sign_data.to_json,
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end

    def process_result(result)
      @request_result = result

      Rails.logger.info "lianjifen service result => #{result}"
      if result["meta"]["code"] == 0
        result["data"]
      else
        Rails.logger.error "lianjifen service error => #{result}"
        @service_error = LianjifenClient::Exceptions::ServerLogicError.new(code: result["meta"]["code"], data: result)
        nil
      end
    end

    # 生成支付跳转URL
    def generate_payment_url(token: nil, trade_no: nil, redirect_url: "", back_url: "")
      request_data = {
        lianToken: token,
        preOrderId: trade_no,
        redirectUrl: Base64.urlsafe_encode64(redirect_url),
        backUrl: Base64.urlsafe_encode64(back_url),
      }
      sign_data = SignUtil.generate_lapp_sign_data("lianjifen_app", request_data)
      "#{base_uri}/v1/sa/transaction/payPage?#{sign_data.to_query}"
    end
  end
end
