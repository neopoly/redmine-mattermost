module RedmineMattermost
  module Extractors
    class AppliedChangeset < Base
      MESSAGE = "[%{project_link}] %{editor} updated %{object_link}"
      REVISION_LINK = "<%{url}|%{title}>"

      def from_context(context)
        issue     = context.fetch(:issue)
        changeset = context.fetch(:changeset)
        journal   = issue.current_journal

        return if issue.is_private?
        return unless issue.valid?
        return unless channel = determine_channel(issue.project)
        return unless url = determine_url(issue.project)

        args = {
          project_link: link(issue.project, event_url(issue.project)),
          editor: h(journal.user),
          object_link: link(issue, event_url(issue))
        }

        msg = MessageBuilder.new(MESSAGE % args)
        msg.channel(channel)
        msg.icon(determine_icon(issue.project))
        msg.username(determine_username(issue.project))
        attachment = msg.attachment
        attachment.text(t("text_status_changed_by_changeset", value: revision_link(changeset)))
        mapper = Utils::JournalMapper.new(bridge)
        mapper.to_fields(journal).map do |field|
          attachment.field(*field)
        end

        { url: url, message: msg.to_hash }
      end

      private

      def revision_link(changeset)
        repository = changeset.repository
        options = default_url_options.merge(
          controller: "repositories",
          action: "revision",
          id: repository.project,
          repository_id: repository.identifier_param,
          rev: changeset.revision
        )
        REVISION_LINK % {
          url: bridge.url_for(options),
          title: h(changeset.comments)
        }
      end
    end
  end
end
