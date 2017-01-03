require "./lib/newline_hw/shell/run"

describe NewlineHw::Shell::Runners do
  describe NewlineHw::Shell::Runners::Ruby do
    let(:path) { File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "rails")) }
    it "can determine contents of project" do
      expect(NewlineHw::Shell::Runners::Ruby.new(path).file?("Gemfile")).to eq true
    end

    it "can build commands based upon the contents of project" do
      expect(NewlineHw::Shell::Runners::Ruby.new(path).commands).to include "bin/rake db:setup"
    end
  end

  describe NewlineHw::Shell::Runners::Javascript do
    let(:path) { File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "javascript")) }
    it "can determine contents of project" do
      expect(NewlineHw::Shell::Runners::Javascript.new(path).file?("package.json")).to eq true
    end

    it "can build commands based upon the contents of project" do
      expect(NewlineHw::Shell::Runners::Javascript.new(path).commands).to eq ["npm install"]
    end
  end
end
