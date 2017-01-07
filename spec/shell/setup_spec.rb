require "./lib/newline_hw/shell/setup"

describe NewlineHw::Shell::Setup do
  let(:config) {double(:config, homework_dir: "./tmp")}

  it "can generate a setup command based upon an id" do
    # expect(NewlineHw::Shell::Setup.new(1, config).cmd).to include "hw"
  end

  describe "for a git url" do
    subject(:setup) { NewlineHw::Shell::Setup.new("git@github.com:TIYDC/tiyo-hw.git", config) }

    it "can generate a setup command" do
      expect(setup.cmd.scan("cd ").size).to eq 2
    end
  end

  describe "for a gist url" do
    subject(:setup) do
      NewlineHw::Shell::Setup.new(
        "https://gist.github.com/caseywatts/8eec8ff974dee9f3b247", config
      )
    end

    it "can generate a setup command" do
      expect(setup.cmd.scan("cd ").size).to eq 2
    end

    it "will not attempt to clone a sha" do
      expect(setup.cmd).to_not match "git checkout"
    end
  end

  describe "when a normal github repo" do
    subject(:setup) do
      NewlineHw::Shell::Setup.new(
        "https://github.com/barnameh/Time-Entry-Data.git", config
      )
    end

    it "does not detect a pr" do
      expect(setup.pr?).to be_falsey
    end

    it "does not mutate git url" do
      expect(setup.git_url).to eq "https://github.com/barnameh/Time-Entry-Data.git"
    end

  end

  describe "for a github pullrequest url" do
    subject(:setup) do
      NewlineHw::Shell::Setup.new(
        "https://github.com/jamesdabbs/lita-panic/pull/5", config
      )
    end

    it "can generate a setup command" do
      expect(setup.cmd.scan("cd ").size).to eq 2
    end

    it "can detect a pr" do
      expect(setup.pr?).to be_truthy
    end

    it "can infer a pr's git url" do
      expect(setup.git_url).to eq "https://github.com/jamesdabbs/lita-panic.git"
    end

    it "will attempt to checkout branch of pull" do
      expect(setup.cmd).to match "git checkout submitted_assignment"
    end
  end
end
