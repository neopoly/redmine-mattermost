module RedmineMattermost
  module Extractors
    class Base
      include Utils::Text
      include Utils::Urls

      CUSTOM_FIELD_URL = "Mattermost URL"
      CUSTOM_FIELD_CHANNEL = "Mattermost Channel"
      BLACK_HOLE_CHANNEL = "-"
      MENTIONS = "\nTo: %{usernames}"

      attr_reader :bridge

      def initialize(bridge)
        @bridge = bridge
      end

      protected

      def determine_channel(project)
        return if project.nil? || project.blank?

        cf = custom_field(CUSTOM_FIELD_CHANNEL)

        [
          (project.custom_value_for(cf).value rescue nil),
          determine_channel(project.parent),
          settings.plugin_redmine_mattermost[:channel],
        ].find { |v| !v.nil? && !v.empty? && v != BLACK_HOLE_CHANNEL }
      end

      def determine_url(project)
        return if project.nil? || project.blank?
        cf = custom_field(CUSTOM_FIELD_URL)

        [
          (project.custom_value_for(cf).value rescue nil),
          determine_url(project.parent),
          settings.plugin_redmine_mattermost[:mattermost_url],
        ].find { |v| !v.nil? && !v.empty? }
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

      protected

      def settings
        bridge.settings
      end

      private

      def custom_field(name)
        bridge.custom_field_by_name(name)
      end
    end
  end
end

require "redmine_mattermost/extractors/applied_changeset"
require "redmine_mattermost/extractors/changed_wiki_page"
require "redmine_mattermost/extractors/new_issue"
require "redmine_mattermost/extractors/updated_issue"
