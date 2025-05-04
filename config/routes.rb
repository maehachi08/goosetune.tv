Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'

  # YouTube検索
  namespace :youtubes do
    # Youtubes Controller
    get '/',                          :action => 'index'
    get '/_live',                     :action => '_live'
    get '/keyword',                   :action => 'keyword'
    get '/_upload_month',             :action => '_upload_month'
    get '/upload_month/:year/:month', :action => 'upload_month'
    get '/today/:year/:month/:day',   :action => 'today'
    get '/new_arrival',               :action => 'new_arrival'
    get '/view_counts',               :action => 'view_counts'
    get '/desc',                      :action => 'desc'
    get '/asc',                       :action => 'asc'
    get '/sing',                      :action => 'sing'
    get '/playyouhouse',              :action => 'playyouhouse'
    get '/cover',                     :action => 'cover'
    get '/cover/:year',               :action => 'yearly_cover'

    # Youtubes::Hoy Controller
    get '/hoy'       => 'hoy#index'
    get '/hoy/:year' => 'hoy#by_year'

    # Youtubes::Release Controller
    get '/release_at/year'         => 'release_at#year'
    get '/release_at/years'        => 'release_at#years'
    get '/release_at/year/:year'   => 'release_at#by_year'
    get '/release_at/years/:years' => 'release_at#by_years'

    get '/:youtube_id', :action => 'entry'
  end

  # Ustream検索
  namespace :ustreams do
    # Ustream Controller
    get '/',            :action => 'index'
    get '/hoy',         :action => 'hoy'
    get '/view_counts', :action => 'view_counts'
    get '/desc',        :action => 'desc'
    get '/asc',         :action => 'asc'
    get '/_published',  :action => '_published'
    get '/:ustream_id', :action => 'entry'
  end

  # メンバー検索
  namespace :members do
    get '/refine'                  => 'refine#_refine'
    get '/refine/:refine_members'  => 'refine#index'

    # 時代時代の全員曲検索結果
    get '/pyhouse/phase1'    => 'refine#_refine_each_by_phase', :phase => '1', :name => 'pyhouse'
    get '/pyhouse/phase2'    => 'refine#_refine_each_by_phase', :phase => '2', :name => 'pyhouse'
    get '/goosehouse/phase1' => 'refine#_refine_each_by_phase', :phase => '1', :name => 'goosehouse'
    get '/goosehouse/phase2' => 'refine#_refine_each_by_phase', :phase => '2', :name => 'goosehouse'
    get '/goosehouse/phase3' => 'refine#_refine_each_by_phase', :phase => '3', :name => 'goosehouse'
    get '/goosehouse/phase4' => 'refine#_refine_each_by_phase', :phase => '4', :name => 'goosehouse'
    get '/goosehouse/phase5' => 'refine#_refine_each_by_phase', :phase => '5', :name => 'goosehouse'
    get '/goosehouse/phase6' => 'refine#_refine_each_by_phase', :phase => '6', :name => 'goosehouse'
    get '/goosehouse/phase7' => 'refine#_refine_each_by_phase', :phase => '7', :name => 'goosehouse'
    get '/goosehouse/phase8' => 'refine#_refine_each_by_phase', :phase => '8', :name => 'goosehouse'

    get '/',           :action => 'index'
    get '/:member_id', :action => 'entry'
  end

  get '/unit_groups'                => 'unit_groups#index'
  get '/unit_groups/:unit_group_id' => 'unit_groups#entry'

  get '/artists'            => 'artists#index'
  get '/artists/:artist_id' => 'artists#entry'

  namespace :musical_instruments do
    get '/',                                 :action => 'index'
    get '/player'                                    => 'player#index'
    get '/:musical_instruments_id',          :action => 'entry'
    get '/:musical_instruments_id/player'            => 'player#list'
    get '/:musical_instruments_id/player/:member_id' => 'player#entry'
  end

  get '/genres'           => 'genres#index'
  get '/genres/:genre_id' => 'genres#entry'


  namespace :api do
    namespace :v2 do
      namespace :youtubes do
        get '/',                          :action => 'index'
        get '/keyword',                   :action => 'keyword'
        get '/upload_month/:year/:month', :action => 'upload_month'
        get '/new_arrival',               :action => 'new_arrival'
        get '/desc',                      :action => 'desc'
        get '/asc',                       :action => 'asc'
        get '/view_counts',               :action => 'view_counts'
        get '/playyouhouse',              :action => 'playyouhouse'
        get '/sing',                      :action => 'sing'
        get '/cover',                     :action => 'cover'
        get '/cover/:year',               :action => 'cover_by_year'
        get '/today/:year/:month/:day',   :action => 'today'
        get '/lives',                     :action => 'lives'
        get '/:id',                       :action => 'entry'
        namespace :release_at do
          get '/year' ,        :action => 'year'
          get '/year/:year' ,  :action => 'by_year'
          get '/years',        :action => 'years'
          get '/years/:years', :action => 'by_years'
        end
        namespace :hoy do
          get '/' ,      :action => 'index'
          get '/:year' , :action => 'by_year'
        end
      end

      namespace :members do
        get '/',    :action => 'index'
        get '/:id', :action => 'entry'

        namespace :refine do
          get '/:ids',           :action => 'entry'
          get '/pyhouse/phase/:id',    :action => 'pyhouse'
          get '/goosehouse/phase/:id', :action => 'goosehouse'
        end
      end

      namespace :artists do
        get '/',    :action => 'index'
        get '/:id', :action => 'entry'
      end

      namespace :unit_groups do
        get '/',    :action => 'index'
        get '/:id', :action => 'entry'
      end

      namespace :musical_instruments do
        get '/',    :action => 'index'

        namespace :player do
          get '/',           :action => 'index'
        end

        get '/:id', :action => 'entry'

        scope '/:musical_instrument_id' do
          namespace :player do
            get '/',           :action => 'player_with_musical_instrument'
            get '/:member_id', :action => 'player_with_member'
          end
        end

      end

      namespace :genres do
        get '/',    :action => 'index'
        get '/:id', :action => 'entry'
      end

      namespace :ustreams do
        get '/',            :action => 'index'
        get '/desc',        :action => 'desc'
        get '/asc',         :action => 'asc'
        get '/view_counts', :action => 'view_counts'
        get '/hoy',         :action => 'hoy'
        get '/hoy/:year',   :action => 'hoy_by_year'
        get '/:id',         :action => 'entry'
      end

    end
  end
end
