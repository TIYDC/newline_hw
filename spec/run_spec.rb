require "./lib/newline_hw/shell/run"

describe NewlineHw::Shell::Run do
  let(:path) { File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "ruby")) }
  it "can generate a command to be run" do
    expect(NewlineHw::Shell::Run.new(path).cmd).to eq "bundle install"
  end
end
