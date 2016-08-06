require "./lib/tiyo_hw/run"

describe TiyoHw::Runners do
  describe TiyoHw::Runners::Ruby do
    let(:path) { File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "rails")) }
    it "can determine contents of project" do
      expect(TiyoHw::Runners::Ruby.new(path).file?("Gemfile")).to eq true
    end

    it "can build commands based upon the contents of project" do
      expect(TiyoHw::Runners::Ruby.new(path).commands).to include "bin/rake db:setup"
    end
  end

  describe TiyoHw::Runners::Javascript do
    let(:path) { File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "javascript")) }
    it "can determine contents of project" do
      expect(TiyoHw::Runners::Javascript.new(path).file?("package.json")).to eq true
    end

    it "can build commands based upon the contents of project" do
      expect(TiyoHw::Runners::Javascript.new(path).commands).to eq ["npm install"]
    end
  end
end
