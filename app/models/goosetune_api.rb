require 'net/http'
require 'uri'

class GoosetuneApi
  include ActiveModel::Model

  def initialize()
    @api_endpoint = ENV['API_ENDPOINT_URL']
    @api_endpoint_port = ENV['API_ENDPOINT_PORT']
  end

  def get_data(params, api_path)
    http = Net::HTTP.new(@api_endpoint, @api_endpoint_port)

    # if ENV['RAILS_ENV'] == "production"
    #   http.use_ssl = true
    # end

    # http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(api_path)
    res = http.request(request)
    puts api_path
    puts res.body
    JSON.parse(res.body)
  end

  def get_paginate_data(params, api_path)
    keyword = params.dig(:search, :keyword).presence
    page    = params[:page].presence

    if params[:page].nil?

      http = Net::HTTP.new(@api_endpoint, @api_endpoint_port)

      if keyword
        params = URI.encode_www_form(
          {keyword: keyword}
        )
        request = Net::HTTP::Get.new("#{api_path}?#{params}")
      else
        request = Net::HTTP::Get.new(api_path)
      end

      res = http.request(request)
    else
      page = params[:page]
      http = Net::HTTP.new(@api_endpoint, @api_endpoint_port)
      if keyword
        params = URI.encode_www_form(
          {
            keyword: keyword,
            page: page
          }
        )
      else
        params = URI.encode_www_form({page: page})
      end

      request = Net::HTTP::Get.new("#{api_path}?#{params}")
      res = http.request(request)
    end

    _data = JSON.parse(res.body)
    contents_data = _data['contents']
    common = _data['common']

    headers = {}
    res.each_header do |name, value|
      headers[name] = value
    end

    # ==== Kaminari.paginate_array options
    # kaminari-core-1.1.1/lib/kaminari/models/array_extension.rb
    # * <tt>:limit</tt> - limit
    # * <tt>:offset</tt> - offset
    # * <tt>:total_count</tt> - total_count
    # * <tt>:padding</tt> - padding
    if contents_data.class.to_s == 'Array'
      data =
        Kaminari.paginate_array(
          contents_data,:total_count => headers['x-total'].to_i
        )
        .page(headers['x-page'])
        .per(headers['x-per-page'])
      return data, common, headers
    else
      youtubes =
        Kaminari.paginate_array(
          contents_data['youtubes'], :total_count => headers['x-total'].to_i
        )
        .page(headers['x-page'])
        .per(headers['x-per-page'])
      contents_data['youtubes'] = youtubes
      data = contents_data
      return data, common, headers
    end
  end
end
