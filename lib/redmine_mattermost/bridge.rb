module RedmineMattermost
  class Bridge
    def settings
      ::Setting
    end

    def custom_field_by_name(name)
      ::ProjectCustomField.find_by_name(name)
    end

    def url_for(target)
      ::Rails.application.routes.url_for(target)
    end

    def translate(*args)
      ::I18n.t(*args)
    end

    def find_custom_field(id)
      ::CustomField.find_by_id(id)
    end

    def find_tracker(id)
      ::Tracker.find_by_id(id)
    end

    def find_project(id)
      ::Project.find_by_id(id)
    end

    def find_issue_status(id)
      ::IssueStatus.find_by_id(id)
    end

    def find_issue_priority(id)
      ::IssuePriority.find_by_id(id)
    end

    def find_issue_category(id)
      ::IssueCategory.find_by_id(id)
    end

    def find_user(id)
      ::User.find(id)
    end

    def find_version(id)
      ::Version.find_by_id(id)
    end

    def find_attachement(id)
      ::Attachment.find_by_id(id)
    end

    def find_issue(id)
      ::Issue.find_by_id(id)
    end
  end
end
