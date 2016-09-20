require "spec_helper"

describe RedmineMattermost::Extractors::AppliedChangeset do
  subject { RedmineMattermost::Extractors::AppliedChangeset.new(bridge) }
  let(:result) { subject.from_context(context) }
  let(:msg)    { result[:message] }
  let(:context) do
    { issue: issue, changeset: changeset }
  end
  let(:bridge)    { MockBridge.new(settings) }
  let(:issue)     { MockIssue.new(issue_data) }
  let(:journal)   { mock(journal_data) }
  let(:changeset) { mock(changeset_data)}
  let(:settings) { Defaults.settings }

  let(:issue_data) do
    {
      title: "Some title",
      project: EventMock.new(title: "Project A"),
      current_journal: journal,
      valid: true
    }
  end
  let(:journal_data) do
    {
      user: "User A",
      details: [mock(prop_key: "title", value: "Some title")]
    }
  end
  let(:changeset_data) do
    {
      repository: mock({
        project: EventMock.new(title: "Project A"),
        identifier_param: "repo_1",
      }),
      revision: "revision_1"
    }
  end

  describe "empty context" do
    let(:context) { Hash.new }

    it "raises" do
      proc { result }.must_raise KeyError
    end
  end

  describe "no project" do
    let(:issue_data) do
      { title: "Some title" }
    end

    it "returns nil" do
      result.must_be_nil
    end
  end

  describe "invalid issue" do
    let(:issue_data) do
      { valid: false }
    end
  end

  describe "with changeset" do
    it "should return a message" do
      msg[:text].must_equal(
        "[#{link_for("Project A")}] User A updated #{link_for("Some title")}"
      )
      attachments = msg[:attachments]
      attachments.size.must_equal 1
      attachment  = attachments.shift
      text        = attachment[:text]
      text.must_equal("text_status_changed_by_changeset")
      fields      = attachment[:fields]
      fields.size.must_equal 1
      fields.shift.must_equal({
        title: "field_title",
        value: "Some title"
      })
    end
  end
end
