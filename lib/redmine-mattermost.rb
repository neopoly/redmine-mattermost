require "redmine_mattermost/version"
require "redmine_mattermost/infos"
require "redmine_mattermost/client"
require "redmine_mattermost/message_builder"
require "redmine_mattermost/bridge"
require "redmine_mattermost/utils"
require "redmine_mattermost/extractors"

if defined?(Rails)
  require "redmine_mattermost/engine"
end

# Mattermost chat integration
module RedmineMattermost
end
