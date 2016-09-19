require "redmine-mattermost"

require "minitest/autorun"
require "webmock/minitest"

require_relative "support/mock_support"

class Minitest::Test
  def mock(data)
    Mock.new(data)
  end

  def link_for(label)
    '<URL: {"host":"test.host","protocol":"http","port":null,' \
    '"script_name":null}|' + label + '>'
  end
end
