module RedmineMattermost
  module Utils
    class JournalMapper
      include Text
      include Urls

      attr_reader :bridge

      def initialize(bridge)
        @bridge = bridge
      end

      def to_fields(journal)
        journal.details.map do |detail|
          detail_to_field(detail)
        end
      end

      private

      def detail_to_field(detail)
        short = true
        value = h(detail.value)

        if detail.property == "cf"
          key   = bridge.find_custom_field(detail.prop_key).name rescue nil
          title = key
        elsif detail.property == "attachment"
          key   = "attachment"
          title = t("label_attachment")
        else
          key   = detail.prop_key.to_s.sub("_id", "")
          title = t("field_#{key}")
        end

        case key
        when "title", "subject", "description"
          short = false
        when "tracker"
          tracker = bridge.find_tracker(detail.value)
          value   = h tracker.to_s
        when "project"
          project = bridge.find_project(detail.value)
          value   = h project.to_s
        when "status"
          status = bridge.find_issue_status(detail.value)
          value  = h status.to_s
        when "priority"
          priority = bridge.find_issue_priority(detail.value)
          value    = h priority.to_s
        when "category"
          category = bridge.find_issue_category(detail.value)
          value    = h category.to_s
        when "assigned_to"
          user  = bridge.find_user(detail.value)
          value = h user.to_s
        when "fixed_version"
          version = bridge.find_version(detail.value)
          value   = h version.to_s
        when "attachment"
          if attachment = bridge.find_attachement(detail.prop_key)
            value    = "<#{event_url attachment}|#{h attachment.filename}>"
          end
        when "parent"
          issue = bridge.find_issue(detail.value)
          value = "<#{event_url issue}|#{h issue}>" if issue
        end

        value = "-" if value.nil? || value.empty?

        [title, value, short]
      end
    end
  end
end
