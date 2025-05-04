module ApplicationHelper
  # url_exist?
  #   The present is a method provided by ActiveSupport.
  #   Please install activesupport.
  def url_exist?(url_string)
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == 'https')
    path = url.path if url.path.present?
    res = req.request_head(path || '/')
    res.code != "404" # false if returns 404 - not found
  rescue Errno::ENOENT
    false # false if can't find the server
  end

  require 'bitly'
  def bitly_shorten(url)
    Bitly.use_api_version_3
    Bitly.configure do |config|
      config.api_version = 3
      config.access_token = "3b8748f67f9e9be323e23f960f265a9fa4056e50"
    end
    Bitly.client.shorten(url).short_url
  end

end
