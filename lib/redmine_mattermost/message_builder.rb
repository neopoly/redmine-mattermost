module RedmineMattermost
  class MessageBuilder
    DEFAULTS = {
      link_names: 1
    }

    def initialize(message)
      @data = DEFAULTS.merge(text: message)
      @attachments = []
    end

    def to_hash
      @data.dup.tap do |hash|
        unless @attachments.empty?
          hash[:attachments] = @attachments.map(&:to_hash)
        end
      end
    end

    def username(name)
      @data[:username] = name
    end

    def channel(id)
      @data[:channel] = id
    end

    def icon(url)
      @data[:icon_url] = url unless url.nil? || url.empty?
    end

    def attachment
      Attachment.new.tap do |am|
        @attachments << am
      end
    end

    class Attachment
      def initialize()
        @data = { }
      end

      def text(message)
        @data[:text] = message
        self
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
