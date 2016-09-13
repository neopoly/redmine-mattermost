require "redmine_mattermost/redmine_plugin"

module RedmineMattermost
  # Simple engine to support the Redmine plugin
  class Engine < ::Rails::Engine
    config.to_prepare do
      RedminePlugin.new
    end
  end
end
