require "./lib/newline_hw/shell/setup"

describe NewlineHw::Shell::Setup do
  let(:config) { double(:config, homework_dir: "./tmp") }

  describe "for a newline id" do
    subject(:setup) { NewlineHw::Shell::Setup.new("25082", config) }
    let(:json) do
      File.read \
        File.expand_path \
          File.join \
            __FILE__, "..", "..", "fixtures", "newline_assingment_submission.json"
    end

    describe "when auth is present" do
      before do
        expect(NewlineCli::Token).to receive(:get_for_user).and_return("123")

        stub_request(:get, "https://newline.theironyard.com/api/assignment_submissions/25082")
          .to_return(
            body: json
          )
      end

      it "can be detected as cloneable" do
        expect(setup.cloneable?).to be_truthy
      end

      it "can generate a setup command based upon an id" do
        expect(setup.cmd).to include "hw"
      end
    end

    describe "when NO auth" do
      before do
        allow(NewlineCli::Token).to receive(:get_for_user).and_raise \
          NewlineCli::AuthenticationError
      end

      it "can be detected as cloneable" do
        expect { setup.cloneable? }.to \
          raise_error(NewlineCli::AuthenticationError)
      end
    end
  end

  describe "for a git url" do
    subject(:setup) { NewlineHw::Shell::Setup.new("git@github.com:TIYDC/tiyo-hw.git", config) }

    it "can be detected as cloneable" do
      expect(setup.cloneable?).to be_truthy
    end

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

    it "can be detected as cloneable" do
      expect(setup.cloneable?).to be_truthy
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
        "https://github.com/barnameh/Time-Entry-Data", config
      )
    end

    it "can be detected as cloneable" do
      expect(setup.cloneable?).to be_truthy
    end

    it "does not detect a pr" do
      expect(setup.pr?).to be_falsey
    end

    it "does will mutate git url to be git endpoint" do
      expect(setup.git_url).to eq "https://github.com/barnameh/Time-Entry-Data.git"
    end
  end

  describe "for a github pullrequest url" do
    subject(:setup) do
      NewlineHw::Shell::Setup.new(
        "https://github.com/jamesdabbs/lita-panic/pull/5", config
      )
    end

    it "can be detected as cloneable" do
      expect(setup.cloneable?).to be_truthy
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

  describe "for a non git url" do
    subject(:setup) do
      NewlineHw::Shell::Setup.new(
        "https://google.com", config
      )
    end

    it "can be detected as not cloneable" do
      expect(setup.cloneable?).to be_falsey
    end
  end
end
