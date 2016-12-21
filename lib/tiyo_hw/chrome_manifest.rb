require 'json'
module TiyoHw
  module ChromeManifest
    NAME = "com.the_iron_yard.newline_hw_cli"


    def binary_path
      File.expand_path File.join(__FILE__, "..", "..", "..", "bin", "tiyohw")
    end

    def native_messaging_manifest_path
      File.expand_path("~/Library/Application Support/Google/Chrome/NativeMessagingHosts/#{NAME}.json")
    end

    def generate
      spec = Gem::Specification::load("homework.gemspec")
      JSON.pretty_generate({
        name: NAME,
        description: spec.description,
        path: binary_path,
        type: "stdio",
        allowed_origins: [
          "chrome-extension://aonjmhddadffdpljpnfnilhmhfgfbbdp/"
        ]
      })
    end

    def write
      begin
        Dir.mkdir(File.dirname(native_messaging_manifest_path))
      rescue Errno::EEXIST
      end
      File.open(native_messaging_manifest_path, "w+") {|f| f.write(ChromeManifest.generate) }
    end

    extend self
  end
end
