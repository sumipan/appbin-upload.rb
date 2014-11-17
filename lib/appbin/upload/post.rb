require 'faraday'
require 'uri'

module Appbin
module Upload
  class Post

    attr_accessor :endpoint, :aapt

    def initialize(options)
      options.each do |k,v|
        send(k.to_s + '=', v)
      end
    end

    def upload(path)
      raise 'File not found.' unless File.exist?(path)

      if @aapt then
        command = "#{@aapt} l -a #{path}"
        versionName = `#{command}`.match(/android:versionName\(.+?\)="(.+?)"/)[1]
      else
        versionName = 'Unknown'
      end

      uri = URI.parse(@endpoint)

      conn = Faraday.new(:url => sprintf('%s://%s:%s', uri.scheme, uri.hostname, uri.port)) do |builder|
        builder.request :multipart
        builder.request :url_encoded
        builder.adapter :net_http
      end

      if uri.user then
        conn.basic_auth uri.user, uri.password
      end

      params = {
        :files => Faraday::UploadIO.new(path, 'multipart/form-data')
      }

      response = conn.post uri.path, params

      {
        "bundle_version" => "#{versionName} (#{versionName})",
        "install_url"    => response.headers['location'],
      }
    end
  end
end
end
