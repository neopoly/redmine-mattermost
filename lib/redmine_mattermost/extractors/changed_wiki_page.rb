module RedmineMattermost
  module Extractors
    class ChangedWikiPage < Base
      MESSAGE = "[%{project_link}] %{editor} updated %{object_link}"

      def from_context(context)
        page    = context.fetch(:page)
        project = context.fetch(:project)

        return unless notify?
        return unless channel = determine_channel(project)
        return unless url = determine_url(project)

        args = {
          project_link: link(project, event_url(project)),
          editor: h(page.content.author),
          object_link: link(page.title, event_url(page)),
        }

        msg = MessageBuilder.new(MESSAGE % args)
        msg.channel(channel)
        msg.icon(determine_icon(project))
        msg.username(determine_username(project))
        unless page.content.comments.empty?
          attachment = msg.attachment
          attachment.text(h page.content.comments)
        end

        { url: url, message: msg.to_hash }
      end

      private

      def notify?
        settings.plugin_redmine_mattermost[:post_wiki_updates] == "1"
      end
    end
  end
end
