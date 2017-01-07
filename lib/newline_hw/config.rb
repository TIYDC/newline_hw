require "yaml"

module NewlineHw
  class Config
    CONFIG_PATH = "~/.newline-hw.yaml".freeze
    DEFAULTS = {
      editor: "atom",
      terminal: "Terminal",
      start_editor: true
    }.freeze

    def config
      @config ||= DEFAULTS.merge(YAML.load_file(CONFIG_PATH))
    end

    def editor
      config["editor"]
    end

    def terminal
      config["terminal"]
    end

    def self.install_default
      File.open(CONFIG_PATH, "w+") do |f|
        f.write config.to_yaml
      end
    end
  end
end
