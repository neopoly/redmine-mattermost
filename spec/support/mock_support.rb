require "ostruct"
require "redcloth"

class Mock < OpenStruct
  def to_s
    title
  end
end

class EventMock < Mock
  def event_url(options)
    "URL: #{options.to_json}"
  end
end

class MockIssue < EventMock
  def is_private?
    is_private
  end

  def valid?
    valid
  end
end

class MockBridge
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end

  def custom_field_by_name(name)
    OpenStruct.new(name: name)
  end

  def url_for(target)
    target
  end

  def translate(key, options)
    options[:locale].must_equal(settings.default_language)
    key
  end

  def to_html(formatting, text)
    RedCloth.new(text).to_html
  end

  def find_custom_field(id)
    Mock.new(name: "CustomField #{id}")
  end

  def find_tracker(id)
    "Tracker: #{id}"
  end

  def find_project(id)
    "Project: #{id}"
  end

  def find_issue_status(id)
    "IssueStatus: #{id}"
  end

  def find_issue_priority(id)
    "IssuePriority: #{id}"
  end

  def find_issue_category(id)
    "IssueCategory: #{id}"
  end

  def find_user(id)
    "User: #{id}"
  end

  def find_version(id)
    "Version: #{id}"
  end

  def find_attachement(id)
    MockIssue.new(title: "Attachment: #{id}", filename: "file_#{id}.png")
  end

  def find_issue(id)
    MockIssue.new(title: "Issue: #{id}")
  end
end

class Defaults
  def self.settings
    Mock.new({
      host_name: "https://test.host",
      protocol: "http",
      port: 80,
      script_name: "some_script",
      plugin_redmine_mattermost: plugin_settings,
      text_formatting: "textile",
      default_language: "en"
    })
  end

  def self.plugin_settings
    {
      display_watchers: "1",
      post_updates: "1",
      post_wiki_updates: "1",
      mattermost_url: "http://api.mattermost.org",
      channel: "fallback-channel"
    }
  end
end
