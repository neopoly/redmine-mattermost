require "redmine_mattermost/version"
require "redmine_mattermost/infos"

if defined?(Rails)
  require "redmine_mattermost/engine"
end

# Mattermost chat integration
module RedmineMattermost
end
