# -*- coding: utf-8 -*-

module Facebook
  class Graph
    ROOT = "https://graph.facebook.com"
    attr_accessor :api
    attr_reader :params

    def app_access_token
      return @@app_access_token if @@app_access_token
      Graph.get_app_access_token
    end

    def get
      client = HTTPClient.new
      client.get_content(url)
    rescue => error
      Rails.logger.error error
      '{}'
    end

    def initialize(api, access_token = nil, params = {})
      @api = api
      @access_token = access_token
      @params = HashWithIndifferentAccess.new params
    end

    def post
      client = HTTPClient.new
      client.post_content(url)
    rescue => error
      Rails.logger.error error
      '{}'
    end

    def url
      elements = [ROOT]
      elements << @api
      href = elements.join('/')
      href += "?access_token=#{@access_token}" if @access_token
      @params.each do |key, value|
        href += "&#{key}=#{value}"
      end
      URI.escape href
    end

    class << self
      def get_app_access_token
        client = HTTPClient.new
        href = "#{ROOT}/oauth/access_token?"
        href += "client_id=#{Sengine.system.facebook[:app_id]}"
        href += "&client_secret=#{Sengine.system.facebook[:app_secret]}"
        href += "&grant_type=client_credentials"
        @@app_access_token = client.get_content(href).sub(/^.+=/, '')
      rescue => error
        Rails.logger.error error
        nil
      end
    end
  end
end
