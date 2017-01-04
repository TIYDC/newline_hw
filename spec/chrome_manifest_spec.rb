require "./lib/newline_hw/chrome_manifest"

describe NewlineHw::ChromeManifest do
  subject(:manifest) { NewlineHw::ChromeManifest.generate }
  it "generates a chrome manifest that can be parsed" do
    expect(manifest[:type]).to eq "stdio"
  end

  it "has a path that is relative to the user" do
    expect(manifest[:path]).to end_with "newlinehw_stream_shim"
    expect(manifest[:path]).to include ENV["USER"]
  end

  it "will write a file in the correct directory to expose features to chrome"
end
