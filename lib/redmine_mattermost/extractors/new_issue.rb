module RedmineMattermost
  module Extractors
    class NewIssue < Base
      MESSAGE = "[%{project_link}] %{author} created %{object_link}%{mentions}"

      def from_context(context)
        issue = context.fetch(:issue)
        return if issue.is_private?
        return unless channel = determine_channel(issue.project)
        return unless url = determine_url(issue.project)

        args = {
          project_link: link(issue.project, event_url(issue.project)),
          author: h(issue.author),
          object_link: link(issue, event_url(issue)),
          mentions: extract_mentions(issue.description)
        }

        msg = MessageBuilder.new(MESSAGE % args)
        msg.channel(channel)
        msg.icon(determine_icon(issue.project))
        msg.username(determine_username(issue.project))
        attachment = msg.attachment
        attachment.text(to_markdown issue.description) if issue.description
        add_field(attachment, "field_status", issue.status)
        add_field(attachment, "field_priority", issue.priority)
        add_field(attachment, "field_assigned_to", issue.assigned_to)

        if show_watchers? && !issue.watcher_users.empty?
          add_field(attachment, "field_watcher", issue.watcher_users.join(", "))
        end

        { url: url, message: msg.to_hash }
      end

      private

      def add_field(attachment, key, value)
        value = "-" if value.nil? || value.to_s.empty?
        attachment.field(t(key), h(value), true)
      end
    end
  end
end
