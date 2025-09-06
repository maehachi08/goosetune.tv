class Youtubes::ReleaseAtController < ApplicationController
  def year
    @title = "リリース検索(年別)"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/release_at/year"
      goosetune_api_get_data(params, api_path)
    else
      release_at_year = ::Youtube.release_at_year
      entries = {}
      release_at_year.each do |year|
        entries[year] = ::Youtube.where(
          :release_at => Date.parse("#{year}-01-01")..
                         Date.parse("#{year}-12-31")
        ).limit(1).order("RAND()").first
      end
      @data = {}
      @data['youtubes'] = entries
    end
  end

  def years
    @title = "リリース検索(年代別)"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/release_at/years"
      goosetune_api_get_data(params, api_path)
    else
      release_at_years = ::Youtube.release_at_years
      entries = {}
      release_at_years.each do |year|
        entries[year] = Youtube.where(
          :release_at => Date.parse("#{year}-01-01")..
                         Date.parse("#{year.to_i + 9}-12-31")
        ).limit(1).order("RAND()").first
      end
      @data = {}
      @data['youtubes'] = entries
    end
  end

  def by_year
    year = params[:year]
    @title = "原曲が#{year}年にリリースされた曲"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/release_at/year/#{year}"
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "youtubes/entries"
      end
    else
      @data = {
        'youtubes' => Youtube.where(
          :release_at => Date.parse("#{year}-01-01")..
                         Date.parse("#{year}-12-31")
        ).order('published DESC').page(params[:page])
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "youtubes/entries"
      end
    end
  end

  def by_years
    years = params[:years]
    @title = "原曲が#{years}年代にリリースされた曲"

    if ENV['API_MODE'] == 'true'
      api_path = "/api/v2/youtubes/release_at/years/#{years}"
      goosetune_api_get_paginate_data(params, api_path)

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "youtubes/entries"
      end
    else
      @data = {
        'youtubes' => Youtube.where(
          :release_at => Date.parse("#{years}-01-01")..
                         Date.parse("#{years.to_i + 9}-12-31")
        ).order('published DESC').page(params[:page])
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      else
        render "youtubes/entries"
      end
    end
  end

  private
  def goosetune_api
    GoosetuneApi.new
  end

  def goosetune_api_get_data(params, api_path)
    data = goosetune_api.get_data(params, api_path)
    @data = data['contents']
    @common = data['common']
  end

  def goosetune_api_get_paginate_data(params, api_path)
    @data, @common, @headers = goosetune_api.get_paginate_data(params, api_path)
  end
end
