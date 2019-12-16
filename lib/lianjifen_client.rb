module LianjifenClient
  def self.config
    @config ||= YAML.load_file(File.join(Rails.root, "config/lianjifen-client.yml"))[Rails.env || "development"]
  end
end

require "lianjifen_client/railtie"
require "lianjifen_client/sign_util"
require "lianjifen_client/exceptions"
require "lianjifen_client/lianjifen_base_service"
require "lianjifen_client/lianjifen_service"
require "lianjifen_client/lianjifen_event_service"
require "lianjifen_client/lianjifen_operate_service"
