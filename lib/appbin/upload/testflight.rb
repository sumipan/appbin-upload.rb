require 'faraday'
require 'uri'
require 'json'

module Appbin
module Upload
  class Testflight
    attr_accessor :endpoint, :api_token, :team_token, :distribution_lists, :notify

    def initialize(options)
      @endpoint = 'http://testflightapp.com/api/builds.json'
      options.each do |k,v|
        send(k.to_s + '=', v)
      end
    end

    def upload(path, notes)
      raise 'File not found.' unless File.exist?(path)

      raise 'Only .ipa file supported.' unless path.match(/\.ipa$/)

      uri = URI.parse(@endpoint)

      conn = Faraday.new(:url => sprintf('%s://%s:%s', uri.scheme, uri.hostname, uri.port)) do |builder|
        builder.request :multipart
        builder.request :url_encoded
        builder.adapter :net_http
      end

      params = {
        :notes      => notes,
        :api_token  => @api_token,
        :team_token => @team_token,
        :notify     => (@notify == true) ? 'True' : 'False',
        :distribution_lists => @distribution_lists,
        :file => Faraday::UploadIO.new(path, 'multipart/form-data')
      }

      response = conn.post do |req|
        req.path = uri.path
        req.body = params
        req.options.timeout      = 600
        req.options.open_timeout = 600
      end

      JSON.parse(response.body)
    end
  end
end
end
