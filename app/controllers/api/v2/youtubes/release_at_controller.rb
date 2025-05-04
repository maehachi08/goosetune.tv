class Api::V2::Youtubes::ReleaseAtController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # 原曲のリリース年別
  # /api/v2/youtubes/release_at/year
  #==========================
  def year
    # 年リスト配列( [1950 1951...] )
    release_at_year = ::Youtube.release_at_year

    entries = {}
    release_at_year.each do |year|
      entries[year] = ::Youtube.where(
        :release_at => Date.parse("#{year}-01-01")..
                       Date.parse("#{year}-12-31")
      ).limit(1).order("RAND()").first
    end

    @response_data = {
      'contents': {
        'youtubes': entries
      },
      'common': @common_data
    }

    render json: @response_data
  end

  #==========================
  # 原曲のリリース年検索
  # /api/v2/youtubes/release_at/year/:year
  #==========================
  def by_year
    year = params[:year]
    title = "原曲が#{year}年にリリースされた曲"
    entries = Youtube.where(
      :release_at => Date.parse("#{year}-01-01")..
                     Date.parse("#{year}-12-31")
    ).order('published DESC')

    @response_data = {
      'contents': {
        'youtubes': entries
      },
      'common': @common_data
    }

    resources_with_pagination( Kaminari.paginate_array(entries).page(params[:page]) )
    render json: @response_data
  end

  #==========================
  # 原曲のリリース年代別
  # /api/v2/youtubes/release_at/years
  #==========================
  def years
    # 年代リスト配列( [1950 1960...] )
    release_at_years = ::Youtube.release_at_years

    entries = {}
    release_at_years.each do |year|
      entries[year] = Youtube.where(
        :release_at => Date.parse("#{year}-01-01")..
                       Date.parse("#{year.to_i + 9}-12-31")
      ).limit(1).order("RAND()").first
    end

    @response_data = {
      'contents': {
        'youtubes': entries
      },
      'common': @common_data
    }

    render json: @response_data
  end

  #==========================
  # 原曲のリリース年検索
  # /api/v2/youtubes/release_at/years/:years
  #==========================
  def by_years
    years = params[:years]
    title = "原曲が#{years}年台にリリースされた曲"
    entries = Youtube.where(
      :release_at => Date.parse("#{years}-01-01")..
                     Date.parse("#{years.to_i + 9}-12-31")
    ).order('published DESC')

    @response_data = {
      'contents': {
        'youtubes': entries
      },
      'common': @common_data
    }

    resources_with_pagination( Kaminari.paginate_array(entries).page(params[:page]) )
    render json: @response_data
  end

end
