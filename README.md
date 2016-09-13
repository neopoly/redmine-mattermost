### NOTE: This is a fork of [altsol/redmine_mattermost](https://github.com/altsol/redmine_mattermost) to support a Gem-based plugin for Redmine!

# Mattermost chat plugin for Redmine

This plugin posts updates to issues in your Redmine installation to a Mattermost
channel.

Redmine Supported versions: 2.0.x - 3.2.x.

## Screenshot

![screenshot](https://raw.githubusercontent.com/altsol/redmine_mattermost/assets/screenshot.png)

## Installation

1. Ensure you have a `Gemfile.local` file in your Redmine directory. You may just create an empty file.
2. Register `redmine-mattermost` as a dependency as you would do for any other Ruby project:

		gem "redmine-mattermost", "~> 0.3"
	
3. Run bundler:

   		bundle install

Restart Redmine, and you should see the plugin show up in the Plugins page.
Under the configuration options, set the Mattermost API URL to the URL for an
Incoming WebHook integration in your Mattermost account (see also the next two sections).

## Customized Routing

You can also route messages to different channels on a per-project basis. To
do this, create a project custom field (Administration > Custom fields > Project)
named `Mattermost Channel`. If no custom channel is defined for a project, the parent
project will be checked (or the default will be used). To prevent all notifications
from being sent for a project, set the custom channel to `-`.

For more information, see http://www.redmine.org/projects/redmine/wiki/Plugins (see also next section for an easy configuration demonstration).

## Screenshot Guided Configuration

Step 1: Create an Incoming Webhook in Mattermost (Account Settings > Integrations > Incoming Webhooks).

![step1](https://raw.githubusercontent.com/altsol/redmine_mattermost/assets/step1.png)

Step 2: Configure this Redmine plugin for Mattermost. For per-project customized routing, leave the `Mattermost Channel` field empty and follow the next steps, otherwise all Redmine projects will post to the same Mattermost channel. Be careful when filling the channel field, you need to input the channel's handle, not the display name visible to users. You can find each channel's handle by going inside the channel and click the down-arrow and selecting view info.

![step3](https://raw.githubusercontent.com/altsol/redmine_mattermost/assets/step3.png)

Step 3: For per-project customized routing, first create the project custom field (Administration > Custom fields > Project).

![step4a](https://raw.githubusercontent.com/altsol/redmine_mattermost/assets/step4a.png)
![step4b](https://raw.githubusercontent.com/altsol/redmine_mattermost/assets/step4b.png)

Step 4: For per-project customized routing, configure the Mattermost channel handle inside your Redmine project.

![step5](https://raw.githubusercontent.com/altsol/redmine_mattermost/assets/step5.png)

## Credits

The source code is forked from https://github.com/altsol/redmine_mattermost. Special thanks to the original author and contributors for making this awesome hook for Redmine. This fork is just refactored to allow a Gem-based installation.