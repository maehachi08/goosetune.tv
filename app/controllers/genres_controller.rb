class GenresController < ApplicationController
  def index
    if ENV['API_MODE'] == 'false'
      genres_info = []
      genres = Genre.all

      genres.each do |genre|
        genre_info = {}
        genre_info['genre'] = genre
        genre_info['youtube'] = genre.youtubes.limit(1).order("RAND()").first
        genres_info << genre_info
      end

      @data = genres_info
    else
      api_path = "/api/v2/genres"
      goosetune_api_get_data(params, api_path)
    end
  end

  def entry
    genre_id = params[:genre_id]

    if ENV['API_MODE'] == 'false'
      genre = Genre.find(genre_id)
      youtubes = genre.youtubes.order('published DESC')
      paginated_youtubes = Kaminari.paginate_array(youtubes.to_a).page(params[:page])

      @data = {
        'genre' => genre,
        'youtubes' => paginated_youtubes
      }
      @headers = {
        'x-next-page' => paginated_youtubes.next_page ? paginated_youtubes.next_page.to_s : ''
      }

      if request.xhr? && params[:page].present?
        render partial: 'shared/entry_collection', locals: { entries: @data['youtubes'] }, layout: false
      end
    else
      api_path = "/api/v2/genres/#{genre_id}"
      params.delete('genre_id')
      goosetune_api_get_paginate_data(params, api_path)
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
