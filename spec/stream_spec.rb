require_relative "spec_helper"
require "open3"

describe "Messaging stream handler" do
  let(:payload) do
    {
      event: "heartbeat",
      data: {},
      message_at: Time.now.to_i
    }.stringify_keys
  end
  describe "when sent a heartbeat event" do
    it "will respond with versions of relevant applications" do
      stdin, stdout, stderr = Open3.popen3(File.expand_path(File.join("exe/newline_hw_stream_shim")))

      # send hertbeat message
      NewlineHw::StreamProcessor.write_message(stdin, payload)

      # read response
      response = NewlineHw::StreamProcessor.read_native_json_message(stdout)
      # errors = stderr.read
      # expect(errors).to be_empty
      expect(response['message']).to be_nil
      expect(response['status']).to eq 'ok'
      expect(response["data"]["newline_hw_version"])
        .to eq NewlineHw::VERSION.to_s
    end
  end
end
