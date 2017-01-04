require "./lib/newline_hw/shell/setup"

describe NewlineHw::Shell::Setup do
  it "can generate a setup command based upon an id" do
    # expect(NewlineHw::Shell::Setup.new(1, {}).cmd).to include "hw"
  end

  describe "for a git url" do
    subject(:setup) { NewlineHw::Shell::Setup.new("git@github.com:TIYDC/tiyo-hw.git", {}) }

    it "can generate a setup command" do
      expect(setup.cmd.scan("cd ").size).to eq 2
    end
  end

  describe "for a gist url" do
    subject(:setup) do
      NewlineHw::Shell::Setup.new(
        "https://gist.github.com/caseywatts/8eec8ff974dee9f3b247", {}
      )
    end

    it "can generate a setup command" do
      expect(setup.cmd.scan("cd ").size).to eq 2
    end

    it "will not attempt to clone a sha" do
      expect(setup.cmd).to_not match "git checkout"
    end
  end

  describe "for a github pullrequest url" do
    subject(:setup) do
      NewlineHw::Shell::Setup.new(
        "https://github.com/jamesdabbs/lita-panic/pull/5", {}
      )
    end

    it "can generate a setup command" do
      expect(setup.cmd.scan("cd ").size).to eq 2
    end

    it "will attempt to checkout branch of pull" do
      pending "Need to test if we can pull a PR directly vs hitting api to get relative directory"
      expect(setup.cmd).to match "git checkout"
    end
  end
end
