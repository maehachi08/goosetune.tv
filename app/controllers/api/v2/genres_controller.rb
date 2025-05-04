class Api::V2::GenresController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # ジャンル検索 - トップ
  # /api/v2/genres
  #==========================
  def index
    genres_info = []
    genres = Genre.all

    genres.each do |genre|
      genre_info = {}
      genre_info['genre'] = genre
      genre_info['youtube'] = genre.youtubes.limit(1).order("RAND()").first
      genres_info << genre_info
    end

    @response_data = {
      'contents': genres_info,
      'common': @common_data
    }
    render json: @response_data
  end

  #==========================
  # ジャンル検索 - エントリ検索
  # /api/v2/genres/:genre_id
  #==========================
  def entry
    genre_id = params[:id]
    genre = Genre.find(genre_id)
    youtubes = genre.youtubes.order('published DESC')

    @response_data = {
        'contents': {
            'genre': genre,
            'youtubes': youtubes
        },
        'common': @common_data
    }
    resources_with_pagination( Kaminari.paginate_array(youtubes.to_a).page(params[:page]) )
    render json: @response_data
  end

end
