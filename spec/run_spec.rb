require "./lib/tiyo_hw/run"

describe TiyoHw::Run do
  let(:path) { File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "ruby")) }
  it "can generate a command to be run" do
    expect(TiyoHw::Run.new(path).cmd).to eq "bundle install"
  end
end
