require "spec_helper"

describe RedmineMattermost::MessageBuilder do
  subject    { RedmineMattermost::MessageBuilder.new(text) }
  let(:text) { "Some message" }
  let(:expected) do
    {
      link_names: 1,
      text: text
    }
  end
  it "returns the text as default" do
    result.must_equal(expected)
  end

  it "sets the username" do
    subject.username("TestUser")
    result.must_equal(expected.merge({
      username: "TestUser"
    }))
  end

  it "sets the channel" do
    subject.channel("the-channel")
    result.must_equal(expected.merge({
      channel: "the-channel"
    }))
  end

  it "adds attachments" do
    subject.attachment.text("the text")
    subject.attachment.text("other text")
      .field("title", "value")
      .field("foo", "bar", true)

    result.must_equal(expected.merge({
      attachments: [
        {
          text: "the text"
        },
        {
          text: "other text",
          fields: [
            {
              title: "title",
              value: "value"
            },
            {
              title: "foo",
              value: "bar",
              short: true
            }
          ]
        }
      ]
    }))
  end

  it "set the icon as emoji" do
    subject.icon(":sparkles:")
    result.must_equal(expected.merge({
      icon_emoji: ":sparkles:"
    }))
  end

  it "set the icon as url" do
    subject.icon("http://some.com/test.png")
    result.must_equal(expected.merge({
      icon_url: "http://some.com/test.png"
    }))
  end

  private

  def result
    subject.to_hash
  end
end
