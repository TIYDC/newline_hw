require_relative "spec_helper"

describe NewlineHw::StreamCommandHandler do
  let(:payload) do
    {
      event: "heartbeat",
      data: {},
      message_at: Time.now.to_i
    }.stringify_keys
  end
  describe "when sent a heartbeat event" do
    subject(:handler) { NewlineHw::StreamCommandHandler.new(payload) }

    it "will respond with versions of relevant applications" do
      response = handler.call

      expect(response[:data][:version]).to eq NewlineHw::VERSION
      expect(response[:status]).to eq :ok
    end
  end

  describe "when sent a clone_and_open_submission event" do
    let(:payload) do
      {
        event: "clone_and_open_submission",
        data: { id: 1 },
        message_at: Time.now.to_i
      }.stringify_keys
    end

    subject(:handler) { NewlineHw::StreamCommandHandler.new(payload) }
    before do
      expect_any_instance_of(NewlineHw::GuiTrigger).to \
        receive(:call).and_return(terminal_output: "")
    end

    it "will respond with versions of relevant applications" do
      response = handler.call
      expect(response[:data][:terminal_output]).to eq ""
      expect(response[:status]).to eq :ok
    end
  end

  describe "when sent an event that causes an error" do
    subject(:handler) { NewlineHw::StreamCommandHandler.new(payload) }
    before do
      expect(handler).to \
        receive(:known_event?).and_raise(ArgumentError)
    end

    it "will respond with versions of relevant applications" do
      response = handler.call
      expect(response[:message]).to eq "ArgumentError"
      expect(response[:status]).to eq :fail
    end
  end
end
