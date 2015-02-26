require 'faraday'
require 'uri'
require 'json'

module Appbin
module Upload
  class Alphawing
    attr_accessor :endpoint, :token

    def initialize(options)
      options.each do |k,v|
        send(k.to_s + '=', v)
      end
    end

    def upload(path, notes)
      raise 'File not found.' unless File.exist?(path)

      uri = URI.parse(@endpoint)

      conn = Faraday.new(:url => sprintf('%s://%s:%s', uri.scheme, uri.hostname, uri.port)) do |builder|
        builder.request :multipart
        builder.request :url_encoded
        builder.adapter :net_http
      end

      params = {
        :token       => @token,
        :description => notes,
        :file => Faraday::UploadIO.new(path, 'multipart/form-data')
      }

      response = conn.post do |req|
        req.path = uri.path
        req.body = params
        req.options.timeout      = 600
        req.options.open_timeout = 600
      end

      content = JSON.parse(response.body)['content']

      {
        "bundle_version" => "#{content['version']} (#{content['version']}) ##{content['revision']}",
        "install_url"    => content['install_url'],
        "qr_code_url"    => content['qr_code_url'],
      }
    end
  end
end
end
