require "spec_helper"

describe RedmineMattermost::Client do
  subject   { RedmineMattermost::Client.new(url) }
  let(:url) { "http://test.host/api/v3" }

  it "use the given url" do
    subject.url.must_equal url
  end

  it "speak the message as payload" do
    message = {
      text: "Some message",
      username: "TestUser"
    }

    stub_endpoint
      .with(body: { payload: message.to_json })
      .to_return(body: "{}")

    subject.speak(message)
  end

  private

  def stub_endpoint
    stub_request(:post, url)
  end
end
