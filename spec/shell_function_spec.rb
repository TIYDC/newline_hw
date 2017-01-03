require "./lib/newline_hw/shell/function"

describe NewlineHw::Shell::Function do
  it "can generate a function" do
    expect(NewlineHw::Shell::Function.cmd).to include "hw"
  end
end
