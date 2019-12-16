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

    def req_process_result(resp)
      request_url = resp.request.uri.to_s
      Rails.logger.info "[#{DateTime.now}] lianjifen result url: #{request_url}\n#{resp.request.options}\n#{resp.body.force_encoding(Encoding::UTF_8)}"
      result = JSON.parse(resp.body)
      @request_result = result
      if result["meta"]["code"] == 0
        Rails.logger.info "[#{DateTime.now}] lianjifen result url: #{request_url} => #{result}"
        result["data"]
      else
        Rails.logger.error "[#{DateTime.now}] lianjifen error url: #{request_url} => #{result}"
        nil
      end
    end
  end
end
