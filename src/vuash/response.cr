require "json"

module Vuash
  struct Response
    JSON.mapping(
      id: String?,
      error: String?,
      data: String?,
    )
  end
end
