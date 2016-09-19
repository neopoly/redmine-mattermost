module RedmineMattermost
  module Utils
    module Text
      def h(text)
        text.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;") if text
      end

      def t(key, options = {})
        opts = {locale: bridge.settings.default_language}.merge(options)
        bridge.translate(key, opts)
      end

      def link(label, target)
        "<#{target}|#{h label}>"
      end
    end
  end
end
