require "httpclient"

module RedmineMattermost
  class Client
    SSL_VERSION = "SSLv23".freeze

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def speak(message)
      build_http_client.post_async(url, payload: message.to_json)
    end

    private

    def build_http_client
      HTTPClient.new.tap do |http|
        http.ssl_config.cert_store.set_default_paths
        http.ssl_config.ssl_version = SSL_VERSION
      end
    end
  end
end
