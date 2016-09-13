module RedmineMattermost
  # Registers this gem a Redmine plugin and applies the needed patches
  class RedminePlugin
    include RedmineMattermost::Infos

    DEFAULT_SETTINGS = {
      "callback_url" => "http://example.com/callback/",
      "channel" => nil,
      "icon" => "https://raw.githubusercontent.com/altsol/redmine_mattermost/assets/icon.png",
      "username" => "redmine",
      "display_watchers" => "no"
    }.freeze

    SETTING_PARTIAL = "settings/mattermost_settings"

    def initialize
      register!
      boot!
    end

    private

    def register!
      Redmine::Plugin.register :redmine_mattermost do
        name NAME
        author AUTHORS.join(", ")
        description DESCRIPTION
        version VERSION
        url URL
        author_url AUTHOR_URL
        directory Engine.root

        requires_redmine version_or_higher: "2.0.0"

        settings default: DEFAULT_SETTINGS, partial: SETTING_PARTIAL
      end
    end

    def boot!
      require "redmine_mattermost/listener"
      require "redmine_mattermost/issue_patch"

      unless Issue.included_modules.include? RedmineMattermost::IssuePatch
        Issue.send(:include, RedmineMattermost::IssuePatch)
      end
    end
  end
end
