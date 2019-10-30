module LianjifenClient
  class LianjifenBaseService
    attr_accessor :request_result

    # 链积分商户
    def lianjifen_sign(request_data)
      sign_data = SignUtil.generate_common_sign_data("lianjifen", request_data)
      return sign_data.slice(:timestamp, :app_key, :sign)
    end

    # 链积分应用
    def lianjifen_lapp_sign(request_data)
      sign_data = SignUtil.generate_lapp_sign_data("lianjifen_app", request_data)
      return sign_data.slice(:timestamp, :lapp_key, :sign)
    end

    def lianjifen_hotel_sign(request_data)
      sign_data = SignUtil.generate_sample_sign_data("lianjifen_hotel", request_data)
      return sign_data.slice(:timestamp, :app_key, :sign)
    end
  end
end
