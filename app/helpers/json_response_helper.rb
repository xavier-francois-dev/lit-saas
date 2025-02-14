# frozen_string_literal: true

module JsonResponseHelper
  def parse_json(response)
    JSON.parse(response.body)
  rescue JSON::ParserError => e
    { error: "Invalid JSON response: #{e.message}" }
  end
end
