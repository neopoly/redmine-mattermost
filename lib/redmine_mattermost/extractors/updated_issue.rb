module RedmineMattermost
  module Extractors
    class UpdatedIssue < Base
      MESSAGE = "[%{project_link}] %{editor} updated %{object_link}%{mentions}"

      def from_context(context)
        issue   = context.fetch(:issue)
        journal = context.fetch(:journal)
        return unless notify?
        return if issue.is_private?
        return unless channel = determine_channel(issue.project)
        return unless url = determine_url(issue.project)

        args = {
          project_link: link(issue.project, event_url(issue.project)),
          editor: h(journal.user),
          object_link: link(issue, event_url(issue)),
          mentions: extract_mentions(journal.notes)
        }

        msg = MessageBuilder.new(url, MESSAGE % args)
        msg.channel(channel)
        attachment = msg.attachment
        attachment.text(h journal.notes) if journal.notes
        mapper = Utils::JournalMapper.new(bridge)
        mapper.to_fields(journal).map do |field|
          attachment.field(*field)
        end
        msg.to_hash
      end

      private

      def notify?
        settings.plugin_redmine_mattermost[:post_updates] == "1"
      end
    end
  end
end
