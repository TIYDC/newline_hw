require "./lib/newline_hw/shell_function"

describe NewlineHw::ShellFunction do
  it "can generate a function" do
    expect(NewlineHw::ShellFunction.cmd).to include "hw"
  end
end
