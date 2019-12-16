module LianjifenClient
  class LianjifenEventService < LianjifenBaseService
    include HTTParty

    def base_uri
      "#{LianjifenClient.config["lianjifen"]["op_api_host"]}/rujia/api"
    end

    def event_info(event_id)
      result = JSON.parse(self.class.get(
        "#{base_uri}/activity/state",
        query: { subUuid: event_id },
        headers: { "Content-Type" => "application/json" },
      ).body)
      process_result(result)
    end
  end
end
