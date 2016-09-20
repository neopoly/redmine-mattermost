require "spec_helper"

describe RedmineMattermost::Extractors::UpdatedIssue do
  subject { RedmineMattermost::Extractors::UpdatedIssue.new(bridge) }
  let(:result) { subject.from_context(context) }
  let(:msg)    { result[:message] }
  let(:context) do
    { issue: issue, journal: journal }
  end
  let(:bridge)  { MockBridge.new(settings) }
  let(:issue)   { MockIssue.new(issue_data) }
  let(:journal) { mock(journal_data) }

  let(:settings) { Defaults.settings }
  let(:issue_data) do
    {
      title: "Some title",
      project: EventMock.new(title: "Project A")
    }
  end
  let(:journal_data) { Hash.new }

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

  describe "minimal journal" do
    let(:journal_data) do
      {
        details: [],
        user: mock(title: "User A")
      }
    end

    it "should return a message" do
      msg[:text].must_equal(
        "[#{link_for("Project A")}] User A updated #{link_for("Some title")}"
      )
    end
  end

  describe "full journal" do
    let(:journal_data) do
      {
        details: [
          mock(prop_key: "title", value: "Some title"),
          mock(prop_key: "subject", value: "Some subject"),
          mock(prop_key: "description", value: "Some description"),
          mock(prop_key: "tracker_id", value: 1),
          mock(prop_key: "project_id", value: 1),
          mock(prop_key: "status_id", value: 1),
          mock(prop_key: "priority_id", value: 1),
          mock(prop_key: "category_id", value: 1),
          mock(prop_key: "assigned_to", value: 1),
          mock(prop_key: "fixed_version", value: 1),
          mock(property: "attachment", prop_key: 1),
          mock(prop_key: "parent_id", value: 1),
          mock(prop_key: "other", value: "Some other"),
          mock(property: "cf", prop_key: "empty_cf"),
          mock(property: "cf", prop_key: "other_cf", value: "Some value")
        ],
        user: mock(title: "User A"),
        notes: "This is a note"
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
      text.must_equal "This is a note"
      fields      = attachment[:fields]
      fields.size.must_equal 15
      fields.shift.must_equal({
        title: "field_title",
        value: "Some title"
      })
      fields.shift.must_equal({
        title: "field_subject",
        value: "Some subject"
      })
      fields.shift.must_equal({
        title: "field_description",
        value: "Some description"
      })
      fields.shift.must_equal({
        title: "field_tracker",
        value: "Tracker: 1",
        short: true
      })
      fields.shift.must_equal({
        title: "field_project",
        value: "Project: 1",
        short: true
      })
      fields.shift.must_equal({
        title: "field_status",
        value: "IssueStatus: 1",
        short: true
      })
      fields.shift.must_equal({
        title: "field_priority",
        value: "IssuePriority: 1",
        short: true
      })
      fields.shift.must_equal({
        title: "field_category",
        value: "IssueCategory: 1",
        short: true
      })
      fields.shift.must_equal({
        title: "field_assigned_to",
        value: "User: 1",
        short: true
      })
      fields.shift.must_equal({
        title: "field_fixed_version",
        value: "Version: 1",
        short: true
      })
      fields.shift.must_equal({
        title: "label_attachment",
        value: link_for("file_1.png"),
        short: true
      })
      fields.shift.must_equal({
        title: "field_parent",
        value: link_for("Issue: 1"),
        short: true
      })
      fields.shift.must_equal({
        title: "field_other",
        value: "Some other",
        short: true
      })
      fields.shift.must_equal({
        title: "CustomField empty_cf",
        value: "-",
        short: true
      })
      fields.shift.must_equal({
        title: "CustomField other_cf",
        value: "Some value",
        short: true
      })
    end
  end
end
