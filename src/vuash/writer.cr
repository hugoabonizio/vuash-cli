require "http/client"
require "uuid"

module Vuash::Writer
  extend self

  def run(message)
    headers = HTTP::Headers{"Accept" => "application/json"}
    secret = UUID.new.to_s
    encrypted = AES.encrypt(message, secret)
    body = {"message[data]" => encrypted}
    response = HTTP::Client.post_form("#{URL}", headers: headers, form: body)
    result = parse(response.body)

    return {id: result, secret: secret} if result

    raise ServerException.new("Invalid response from server")
  end

  private def parse(body)
    return unless body
    response = Response.from_json(body)

    return response.id if response.id
  end
end
