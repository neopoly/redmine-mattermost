require "spec_helper"

describe RedmineMattermost::Extractors::ChangedWikiPage do
  subject { RedmineMattermost::Extractors::ChangedWikiPage.new(bridge) }
  let(:result) { subject.from_context(context) }
  let(:msg)    { result[:message] }
  let(:context) do
    { project: project, page: page }
  end
  let(:bridge)  { MockBridge.new(settings) }
  let(:project) { EventMock.new(title: "Project A")}
  let(:page)    { EventMock.new(page_data)}

  let(:settings) { Defaults.settings }
  let(:page_data) do
    {
      title: "Some title",
      content: mock({
        author: mock(title: "User A"),
        comments: ""
      })
    }
  end

  describe "empty context" do
    let(:context) { Hash.new }

    it "raises" do
      proc { result }.must_raise KeyError
    end
  end

  describe "minimal page" do
    it "should return a message" do
      msg[:text].must_equal(
        "[#{link_for("Project A")}] User A updated #{link_for("Some title")}"
      )
    end
  end

  describe "full page" do
    let(:page_data) do
      {
        title: "Some title",
        content: mock({
          author: mock(title: "User A"),
          comments: "The comments"
        })
      }
    end

    it "should return a message" do
      msg[:text].must_equal(
        "[#{link_for("Project A")}] User A updated #{link_for("Some title")}"
      )
      attachments = msg[:attachments]
      attachments.size.must_equal 1
      attachment  = attachments.shift
      text        = attachment[:text]
      text.must_equal "The comments"
    end
  end
end
