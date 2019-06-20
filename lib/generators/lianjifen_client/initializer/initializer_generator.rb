class LianjifenClient::InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def copy_initializer_file
    copy_file "lianjifen-client.yml", "config/lianjifen-client.yml"
  end
end
