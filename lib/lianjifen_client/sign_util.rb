module LianjifenClient
  class SignUtil
    class << self
      #### 验证支付签名 ####
      def notify_sign_check!(sign_type, params)
        params[:lapp_secret_key] = LianjifenClient.config[sign_type]["app_secret_key"]
        sign_data = params.except(:utf8, :authenticity_token, :action, :lapp_key, :callbackUrl, :retryCount, :sign)
        sign_str = generate_sign_str_with_blank(sign_data)
        sign = Digest::MD5.hexdigest(sign_str).upcase
        LianjifenClient::Exceptions::SignError.new(message: '签名错误') if sign != params[:sign]
      end
      #### api接口签名 ####
      def generate_api_sign_data(sign_data, token)
        sign_str = generate_sign_str_with_blank(sign_data)
        sign_str += "&token=#{token || ""}"
        sign = Digest::MD5.hexdigest(sign_str).upcase
        return sign
      end

      #### 营销活动签名 ####
      def generate_common_sign_data(sign_type, sign_data)
        timestamp = sign_data["timestamp"] || DateTime.now.to_i
        sign_data[:timestamp] = timestamp
        phash = sign_data.clone
        phash[:app_secret_key] = LianjifenClient.config[sign_type]["app_secret_key"]
        sign_data_str = generate_sign_str_without_blank(phash)
        Rails.logger.info sign_data_str
        sign_str = Digest::MD5.hexdigest(sign_data_str).upcase
        sign_data[:app_key] = LianjifenClient.config[sign_type]["app_key"]
        sign_data[:sign] = sign_str
        return sign_data
      end

      def generate_sample_sign_data(sign_type, sign_data)
        timestamp = sign_data["timestamp"] || DateTime.now.to_i
        sign_data[:timestamp] = timestamp
        phash = sign_data.clone
        phash[:app_secret_key] = LianjifenClient.config[sign_type]["app_secret_key"]
        sign_data_str = generate_sign_str_without_blank(phash)
        Rails.logger.info sign_data_str
        sign_data_str = sign_data_str.chars.sort.join
        Rails.logger.info sign_data_str
        sign_str = Digest::MD5.hexdigest(sign_data_str).upcase
        sign_data[:app_key] = LianjifenClient.config[sign_type]["app_key"]
        sign_data[:sign] = sign_str
        return sign_data
      end

      # lapp_key
      def generate_lapp_sign_data(sign_type, sign_data)
        timestamp = sign_data["timestamp"] || DateTime.now.to_i
        sign_data[:timestamp] = timestamp
        phash = sign_data.clone
        phash[:lapp_secret_key] = LianjifenClient.config[sign_type]["app_secret_key"]
        sign_data_str = generate_sign_str_without_blank(phash)
        Rails.logger.info sign_data_str
        sign_str = Digest::MD5.hexdigest(sign_data_str).upcase
        sign_data[:lapp_key] = LianjifenClient.config[sign_type]["app_key"]
        sign_data[:sign] = sign_str
        return sign_data
      end

      def generate_sign_str_without_blank(phash)
        phash.sort.map do |k, v|
          if v.present?
            if v.class == Hash or v.class == ActiveSupport::HashWithIndifferentAccess or v.class == Array
              "#{k}=#{v.to_json}"
            else
              "#{k}=#{v}"
            end
          end
        end.reject(&:blank?).join("&")
      end

      def generate_sign_str_with_blank(phash)
        phash.sort.map do |k, v|
          if v.class == Hash or v.class == ActiveSupport::HashWithIndifferentAccess or v.class == Array
            "#{k}=#{v.to_json}"
          else
            "#{k}=#{v}"
          end
        end.join("&")
      end
    end
  end
end
