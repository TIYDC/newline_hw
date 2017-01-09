require "json"
module NewlineHw
  module ChromeManifest
    NAME = "com.theironyard.newlinecli.hw".freeze

    module_function

    def binary_path
      File.expand_path File.join(__FILE__, "..", "..", "..", "exe", "newline_hw_stream_shim")
    end

    def native_messaging_manifest_path
      File.expand_path("~/Library/Application Support/Google/Chrome/NativeMessagingHosts/#{NAME}.json")
    end

    def generate
      {
        name: NAME,
        description: spec.description,
        path: binary_path,
        type: "stdio",
        allowed_origins: [
          "chrome-extension://fnhanbdccpjnnoohoppkeejljjljihcc/",
          "chrome-extension://knldjmfmopnpolahpmmgbagdohdnhkik/"
        ]
      }
    end

    def write
      create_native_messaging_manifest_directory

      File.open(native_messaging_manifest_path, "w+") do |f|
        f.write(JSON.pretty_generate(generate))
      end
    end

    private def create_native_messaging_manifest_directory
      return if Dir.exist?(File.dirname(native_messaging_manifest_path))
      Dir.mkdir(File.dirname(native_messaging_manifest_path))
    end

    private def spec
      @_gemspec ||= Gem::Specification.load(File.expand_path(File.join(NewlineHw.root_path,"newline_hw.gemspec")))
    end
  end
end
