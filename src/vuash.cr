require "./vuash/*"

module Vuash
  class ServerException < Exception; end

  class InvalidPassword < Exception; end

  # TODO replace with actual URL
  URL = "http://localhost:3000/"

  CLI.run(ARGV)
end
