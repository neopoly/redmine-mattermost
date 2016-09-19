require "spec_helper"

describe RedmineMattermost::Extractors::NewIssue do
  subject { RedmineMattermost::Extractors::NewIssue.new(bridge) }
  let(:result) { subject.from_context(context) }
  let(:context) do
    { issue: issue }
  end
  let(:bridge) { MockBridge.new(settings) }
  let(:settings) { Defaults.settings }
  let(:issue)  { MockIssue.new(issue_data) }
  let(:issue_data) { Hash.new }

  describe "empty context" do
    let(:context) { Hash.new }

    it "raises" do
      proc { result }.must_raise KeyError
    end
  end

  describe "no project" do
    let(:issue_data) do
      {
        title: "Some title"
      }
    end

    it "returns nil" do
      result.must_be_nil
    end
  end

  describe "minimal issue" do
    let(:issue_data) do
      {
        title: "Some title",
        project: EventMock.new(title: "Project A"),
        author: mock(title: "User A"),
        watcher_users: [],
        status: "New",
        priority: "Normal",
        assigned_to: mock(title: "User B")
      }
    end

    it "should return a message" do
      result[:text].must_equal(
        "[#{link_for("Project A")}] User A created #{link_for("Some title")}"
      )
      attachments = result[:attachments]
      attachments.size.must_equal 1
      attachment  = attachments.shift
      fields      = attachment[:fields]
      fields.size.must_equal 3
      fields.shift.must_equal({
        title: "field_status",
        value: "New",
        short: true
      })
      fields.shift.must_equal({
        title: "field_priority",
        value: "Normal",
        short: true
      })
      fields.shift.must_equal({
        title: "field_assigned_to",
        value: "User B",
        short: true
      })
    end
  end

  describe "full issue" do
    let(:issue_data) do
      {
        title: "Some title",
        project: EventMock.new(title: "Project A"),
        author: mock(title: "User A"),
        watcher_users: [mock(title: "User C")],
        status: "New",
        priority: "Normal",
        assigned_to: mock(title: "User B"),
        description: "Some description"
      }
    end

    it "should return a message" do
      result[:text].must_equal(
        "[#{link_for("Project A")}] User A created #{link_for("Some title")}"
      )
      attachments = result[:attachments]
      attachments.size.must_equal 1
      attachment  = attachments.shift
      fields      = attachment[:fields]
      fields.size.must_equal 4
      fields.shift.must_equal({
        title: "field_status",
        value: "New",
        short: true
      })
      fields.shift.must_equal({
        title: "field_priority",
        value: "Normal",
        short: true
      })
      fields.shift.must_equal({
        title: "field_assigned_to",
        value: "User B",
        short: true
      })
      fields.shift.must_equal({
        title: "field_watcher",
        value: "User C",
        short: true
      })
    end
  end

  describe "extracts mentions" do
    let(:issue_data) do
      {
        title: "Some title",
        project: EventMock.new(title: "Project A"),
        author: mock(title: "User A"),
        watcher_users: [mock(title: "User C")],
        status: "New",
        priority: "Normal",
        assigned_to: mock(title: "User B"),
        description: "Some description @foo @NOT @bar"
      }
    end

    it "should extract mentions for markdown" do
      settings.text_formatting = "markdown"
      result[:text].must_include("To: @foo, @bar")
    end

    it "should NOT extract mentions for textile" do
      settings.text_formatting = "textile"
      result[:text].wont_include("To: @foo, @bar")
    end
  end
end
