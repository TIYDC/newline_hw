require "./lib/tiyo_hw/shell_function"

describe TiyoHw::ShellFunction do
  it "can generate a function" do
    expect(TiyoHw::ShellFunction.cmd).to eq ""
  end
end
