module RedmineMattermost
  module Utils
    module Urls
      def default_url_options
        settings = bridge.settings
        protocol = settings.protocol
        if settings.host_name.to_s =~ /\A(https?\:\/\/)?(.+?)(\:(\d+))?(\/.+)?\z/i
          host, port, prefix = $2, $4, $5
          { host: host, protocol: protocol, port: port, script_name: prefix }
        else
          { host: settings.host_name, protocol: settings.protocol }
        end
      end

      def event_url(obj)
        bridge.url_for(obj.event_url(default_url_options))
      end
    end
  end
end
