require "json"
require "excon"
require "netrc"

module NewlineHw

  class Api
    DEFAULT_HOST = "https://newline.theironyard.com"

    attr_reader :host

    def initialize
      @host = Api.host
      token = NewlineHw::Token.get_for_user
      @connection = Excon.new(@host, headers: {
        "Authorization" => "token #{token}"
      })
    end

    def post(path, data)
      response = @connection.post(path: "/api/#{path}", body: data.to_json, headers: {
        "Accept"       => "application/json",
        "Content-Type" => "application/json"
      }, expects: [200, 201])
      JSON.parse(response.body)
    end

    def put(path, data)
      response = @connection.put(path: "/api/#{path}", body: data.to_json, headers: {
        "Accept"       => "application/json",
        "Content-Type" => "application/json"
      }, expects: [200, 201])
      JSON.parse(response.body)
    end

    def get(path)
      response = @connection.get(path: "/api/#{path}", expects: 200)
      JSON.parse(response.body)
    end

    def self.auth(data)
      response = Excon.post("#{host}/api/auth", headers: {
        "Content-Type" => "application/json"
      }, body: data)
      raise NewlineHw::AuthenticationError, "Invalid email or password" if response.status != 200
      JSON.parse(response.body)
    end

  private

    def self.host
      ENV["NEWLINE_API_HOST"] || DEFAULT_HOST
    end
  end
end
