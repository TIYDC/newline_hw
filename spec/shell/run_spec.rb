require "./lib/newline_hw/shell/run"

describe NewlineHw::Shell::Run do
  let(:config) { double(:config, launch_editor: true, editor: "vim") }
  let(:path) { File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures", "ruby")) }
  it "can generate a command to be run" do
    expect(NewlineHw::Shell::Run.new(path, config).cmd).to include "bundle install"
  end
end
