require "json"
module NewlineHw
  module ChromeManifest
    NAME = "com.theironyard.newlinecli.hw".freeze

    module_function

    def binary_path
      File.expand_path File.join(__FILE__, "..", "..", "..", "exe", "newlinehw_stream_shim")
    end

    def native_messaging_manifest_path
      File.expand_path("~/Library/Application Support/Google/Chrome/NativeMessagingHosts/#{NAME}.json")
    end

    def generate
      JSON.pretty_generate(
        name: NAME,
        description: spec.description,
        path: binary_path,
        type: "stdio",
        allowed_origins: [
          "chrome-extension://fnhanbdccpjnnoohoppkeejljjljihcc/",
          "chrome-extension://knldjmfmopnpolahpmmgbagdohdnhkik/"
        ]
      )
    end

    def write
      Dir.mkdir(File.dirname(native_messaging_manifest_path)) unless Dir.exist?(File.dirname(native_messaging_manifest_path))
      File.open(native_messaging_manifest_path, "w+") { |f| f.write(ChromeManifest.generate) }
    end

    private def spec
      @_gemspec ||= Gem::Specification.load("newline_hw.gemspec")
    end
  end
end
