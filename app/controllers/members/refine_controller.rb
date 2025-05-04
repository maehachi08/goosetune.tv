class Members::RefineController < ApplicationController
  def _refine
    ids = params[:refine_members].join(',')
    redirect_to "/members/refine/#{ids}"
  end

  def index
    ids = params[:refine_members]
    api_path = "/api/v2/members/refine/#{ids}"
    params.delete('refine_members')
    goosetune_api_get_paginate_data(params, api_path)
  end

  def _refine_each_by_phase
    # +----+-----------------------------+
    # | id | name                        |
    # +----+-----------------------------+
    # |  1 | d-iZe                       |
    # |  2 | 関取 花                     |
    # |  3 | 中村千尋                    |
    # |  4 | 木村正英                    |
    # |  5 | 神田莉緒香                  |
    # |  6 | 齊藤 ジョニー               |
    # |  7 | 竹渕慶                      |
    # |  8 | 工藤秀平                    |
    # |  9 | 竹澤汀                      |
    # | 10 | マナミ                      |
    # | 11 | 沙夜香                      |
    # | 12 | ワタナベシュウヘイ          |
    # +----+-----------------------------+

    case params[:name]
    when 'pyhouse'
      @tweet_title = "その時代の全員曲(Play You. House #{params[:phase]}期)"

      case params[:phase]
      when '1'
        # phase1: d-iZeさん、りおかちゃん、関取花ちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん
        api_path = "/api/v2/members/refine/pyhouse/phase/1"
      when '2'
        # phase1: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん、みぎちゃん、千尋ちゃん
        api_path = "/api/v2/members/refine/pyhouse/phase/2"
      end
    when 'goosehouse'
      @tweet_title = "その時代の全員曲(Goosehouse #{params[:phase]}期)"

      case params[:phase]
      when '1'
        # phase1: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん、みぎちゃん、
        api_path = "/api/v2/members/refine/goosehouse/phase/1"
      when '2'
        # phase2: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん、みぎちゃん、まなみん、さやねえ
        api_path = "/api/v2/members/refine/goosehouse/phase/2"
      when '3'
        # phase3: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ
        api_path = "/api/v2/members/refine/goosehouse/phase/3"
      when '4'
        # phase4: d-iZeさん、りおかちゃん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ
        api_path = "/api/v2/members/refine/goosehouse/phase/4"
      when '5'
        # phase5: d-iZeさん、りおかちゃん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ、わしゅう
        api_path = "/api/v2/members/refine/goosehouse/phase/5"
      when '6'
        # phase6: d-iZeさん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ、わしゅう、ジョニーさん
        api_path = "/api/v2/members/refine/goosehouse/phase/6"
      when '7'
        # phase7: 工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ、わしゅう、ジョニーさん
        api_path = "/api/v2/members/refine/goosehouse/phase/7"
      when '8'
        # phase8: 工藤さん、けいちゃん、まなみん、さやねえ、わしゅう、ジョニーさん
        api_path = "/api/v2/members/refine/goosehouse/phase/8"
      end
    end

    goosetune_api_get_paginate_data(params, api_path)
    render 'index'
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
