require "jwt"
require "yaml"

module NewlineHw
  class Token
    NETRC_KEY = "newline.theironyard.com"

    def self.decode(token)
      payload = JWT.decode(token, nil, false)
      payload[0]
    end

    def self.get_for_path
      path_config = YAML.load_file(".path.config")
      path_config["token"]
    end

    def self.get_for_user
      return ENV["NEWLINE_API_TOKEN"] if ENV["NEWLINE_API_TOKEN"]
      if (netrc = netrc_file[NETRC_KEY])
        netrc["password"]
      else
        raise NewlineHw::AuthenticationError, "No stored credentials or ENV[\"NEWLINE_API_TOKEN\"]"
      end
    end

  private

    def self.netrc_file
      Netrc.read("#{Netrc.home_path}/#{Netrc.netrc_filename}")
    end
  end
end
