module RedmineMattermost
  class MattermostListener < Redmine::Hook::Listener
    def initialize
      @bridge = Bridge.new
    end

    def redmine_mattermost_issues_new_after_save(context)
      process Extractors::NewIssue, context
    end

    def redmine_mattermost_issues_edit_after_save(context)
      process Extractors::UpdatedIssue, context
    end

    def model_changeset_scan_commit_for_issue_ids_pre_issue_update(context)
      process Extractors::AppliedChangeset, context
    end

    def controller_wiki_edit_after_save(context)
      process Extractors::ChangedWikiPage, context
    end

    private

    def process(extractor_class, context)
      notify(extractor_class.new(@bridge).from_context(context))
    end

    def notify(options)
      return unless options
      url     = options.fetch(:url)
      message = options.fetch(:message)

      Client.new(url).speak(message)
    rescue
      # Bury exception for connection errors or other types
    end
  end
end
