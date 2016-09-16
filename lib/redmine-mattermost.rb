require "redmine_mattermost/version"
require "redmine_mattermost/infos"
require "redmine_mattermost/client"

if defined?(Rails)
  require "redmine_mattermost/engine"
end

# Mattermost chat integration
module RedmineMattermost
end
