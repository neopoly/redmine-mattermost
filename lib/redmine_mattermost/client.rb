require "net/http"
require "json"

module RedmineMattermost
  class Client
    SSL_VERSION = "SSLv23".freeze

    attr_reader :uri

    def initialize(url)
      @uri = URI(url)
    end

    def speak(message)
      post_async(payload: message.to_json)
    end

    private

    def post_async(params)
      Thread.new { post(params) }
    end

    def post(params)
      Net::HTTP.post_form(uri, params)
    end
  end
end
