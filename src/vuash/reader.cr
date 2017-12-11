require "http/client"

module Vuash::Reader
  extend self

  def run(uuid, password)
    headers = HTTP::Headers{"Accept" => "application/json"}
    response = HTTP::Client.delete("#{URL}#{uuid}", headers: headers)
    raise MessageNotFound.new if response.status_code == 404
    result = parse(response.body)

    if result
      return AES.decrypt(result, password)
    end

    raise ServerException.new("Invalid response from server")
  end

  private def parse(body)
    return unless body
    response = Response.from_json(body)

    return response.data if response.data
    raise ServerException.new(response.error)
  end
end
