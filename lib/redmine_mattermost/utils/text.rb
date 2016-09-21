require "reverse_markdown"

module RedmineMattermost
  module Utils
    module Text
      MARKDOWN_OPTIONS = {
        unknown_tags: :bypass,
        github_flavored: true
      }.freeze

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

      def to_markdown(text)
        case formatting = bridge.settings.text_formatting
        when "markdown"
          text
        else
          html = bridge.to_html(formatting, text)
          ReverseMarkdown.convert(html, MARKDOWN_OPTIONS).strip
        end
      rescue
        h text
      end
    end
  end
end
