# -*- coding: utf-8 -*-

module Facebook
  class Graph
    ROOT = "https://graph.facebook.com"
    attr_accessor :api
    attr_reader :params

    def get
      client = HTTPClient.new
      client.get_content(url, @params)
    rescue => error
      Rails.logger.error error
    end

    def initialize(api, access_token = nil, params = {})
      @api = api
      @access_token = access_token
      @params = HashWithIndifferentAccess.new params
    end

    def post
      client = HTTPClient.new
      client.post_content(url, @params)
    rescue => error
      Rails.logger.error error
    end

    def url
      elements = [ROOT]
      elements << @api
      elements << "&access_token=#{@access_token}" if @access_token
      elements.join('/')
    end
  end
end
