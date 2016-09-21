module RedmineMattermost
  module Extractors
    class Base
      include Utils::Text
      include Utils::Urls

      CUSTOM_FIELD_URL = "Mattermost URL"
      CUSTOM_FIELD_CHANNEL = "Mattermost Channel"
      CUSTOM_FIELD_ICON = "Mattermost Icon"
      CUSTOM_FIELD_USERNAME = "Mattermost Username"
      BLACK_HOLE_CHANNEL = "-"
      MENTIONS = "\nTo: %{usernames}"

      attr_reader :bridge

      def initialize(bridge)
        @bridge = bridge
      end

      protected

      def determine_channel(project)
        channel = determine_configurable_field(project, :channel, CUSTOM_FIELD_CHANNEL)
        return channel if channel != BLACK_HOLE_CHANNEL
      end

      def determine_url(project)
        determine_configurable_field(project, :mattermost_url, CUSTOM_FIELD_URL)
      end

      def determine_icon(project)
        determine_configurable_field(project, :icon, CUSTOM_FIELD_ICON)
      end

      def determine_username(project)
        determine_configurable_field(project, :username, CUSTOM_FIELD_USERNAME)
      end

      def extract_mentions(text)
        return unless text
        return if uses_textile?
        usernames = extract_usernames(text)
        return if usernames.empty?
        MENTIONS % { usernames: usernames.join(", ") }
      end

      def extract_usernames(text)
        return [] unless text
        return [] if uses_textile?
        text.scan(/@[a-z0-9][a-z0-9_\-]*/).uniq
      end

      def uses_textile?
        settings.text_formatting == "textile"
      end

      def show_watchers?
        settings.plugin_redmine_mattermost[:display_watchers] == "1"
      end

      def settings
        bridge.settings
      end

      private

      def custom_field(name)
        bridge.custom_field_by_name(name)
      end

      def determine_configurable_field(project, settings_key, field_key)
        return if project.nil? || project.blank?
        cf = custom_field(field_key)

        [
          (project.custom_value_for(cf).value rescue nil),
          determine_configurable_field(project.parent, settings_key, field_key),
          settings.plugin_redmine_mattermost[settings_key],
        ].find { |v| !v.nil? && !v.empty? }
      end
    end
  end
end

require "redmine_mattermost/extractors/applied_changeset"
require "redmine_mattermost/extractors/changed_wiki_page"
require "redmine_mattermost/extractors/new_issue"
require "redmine_mattermost/extractors/updated_issue"
