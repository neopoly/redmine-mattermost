module RedmineMattermost
  class MessageBuilder
    DEFAULTS = {
      link_names: 1
    }

    def initialize(message)
      @data = DEFAULTS.merge(text: message)
    end

    def to_hash
      @data.dup.tap do |hash|
        hash[:attachments] = @attachments.map(&:to_hash) if @attachments
      end
    end

    def username(name)
      @data[:username] = name
    end

    def channel(id)
      @data[:channel] = id
    end

    def icon(emoji_or_url)
      return if emoji_or_url.nil? || emoji_or_url.empty?
      if emoji_or_url.start_with?(":")
        @data[:icon_emoji] = emoji_or_url
      else
        @data[:icon_url] = emoji_or_url
      end
    end

    def attachment(text)
      Attachment.new(text).tap do |am|
        (@attachments ||= []) << am
      end
    end

    class Attachment
      def initialize(message)
        @data = { text: message }
      end

      def field(title, value, short = false)
        {title: title, value: value}.tap do |hash|
          hash[:short] = true if short
          (@data[:fields] ||= []) << hash
        end
        self
      end

      def to_hash
        @data.to_hash
      end
    end
  end
end
