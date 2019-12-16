module LianjifenClient
  class LianjifenEventService < LianjifenBaseService
    include HTTParty

    def base_uri
      "#{LianjifenClient.config["lianjifen"]["op_api_host"]}/lianjifen-operation/api"
    end

    def event_info(event_id)
      req = self.class.get(
        "#{base_uri}/activity/state",
        query: { subUuid: event_id },
        headers: { "Content-Type" => "application/json" },
      )
      req_process_result(req)
    end
  end
end
