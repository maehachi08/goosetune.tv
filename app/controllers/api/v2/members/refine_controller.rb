class Api::V2::Members::RefineController < ApplicationController
  include Api::V2::Pagination

  #==========================
  # メンバー絞り込み検索
  # /api/v2/members/refine/:ids
  #==========================
  def entry
    @member_ids = []
    member_ids = params[:ids].split(",")
    member_ids.group_by { |id| @member_ids.push(id.to_i) }

    refine_members = Member.get_members(member_ids)
    unrefine_members = Member.get_unrefine_members(member_ids)
    members = Member.get_all
    entries = Member.get_youtubes_with_refine_members(refine_members)

    @response_data = {
      'contents': {
        'members'          => members,
        'unrefine_members' => unrefine_members,
        'refine_members'   => refine_members,
        'youtubes'         => Kaminari.paginate_array(entries).page(params[:page])
      },
      'common'           => @common_data
    }
    resources_with_pagination( Kaminari.paginate_array(entries).page(params[:page]) )
    render json: @response_data
  end

  #==========================
  # メンバー絞り込み検索
  #==========================
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
  def pyhouse
    phase = params[:id]
    if phase == '1'
      # Play You. House 1期
      # phase1: d-iZeさん、りおかちゃん、関取花ちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん
      member_ids = [1,2,4,5,6,7,8]

    elsif phase == '2'
      # Play You. House 2期
      # phase1: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん、みぎちゃん、千尋ちゃん
      member_ids = [1,3,4,5,6,7,8,9]
    end

    @response_data = refine_members(member_ids)
    render json: @response_data
  end

  def goosehouse
    phase = params[:id]
    if phase == '1'
      # Goosehouse 1期
      # phase1: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん、みぎちゃん、
      member_ids = [1,4,5,6,7,8,9]

      # TODO
      # Play You. House時代の動画がヒットするのは問題ないかどうか検討すること
      # 本来は以下のエントリのみが該当する
      # 'EGqZM0sHBuY'
      # 'F9p9qAmk11c'
      # 'UyJ8Qbh_LH0'

    elsif phase == '2'
      # Goosehouse 2期
      # phase2: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、木村くん、けいちゃん、みぎちゃん、まなみん、さやねえ
      member_ids = [1,4,5,6,7,8,9,10,11]

    elsif phase == '3'
      # Goosehouse 3期
      # phase3: d-iZeさん、りおかちゃん、ジョニーさん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ
      member_ids = [1,5,6,7,8,9,10,11]

    elsif phase == '4'
      # Goosehouse 4期
      # phase4: d-iZeさん、りおかちゃん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ
      member_ids = [1,5,7,8,9,10,11]

    elsif phase == '5'
      # Goosehouse 5期
      # phase5: d-iZeさん、りおかちゃん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ、わしゅう
      member_ids = [1,5,7,8,9,10,11,12]

    elsif phase == '6'
      # Goosehouse 6期
      # phase6: d-iZeさん、工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ、わしゅう、ジョニーさん
      member_ids = [1,6,7,8,9,10,11,12]

    elsif phase == '7'
      # Goosehouse 7期
      # phase7: 工藤さん、けいちゃん、みぎちゃん、まなみん、さやねえ、わしゅう、ジョニーさん
      member_ids = [6,7,8,9,10,11,12]

    elsif phase == '8'
      # Goosehouse 8期
      # phase8: 工藤さん、けいちゃん、まなみん、さやねえ、わしゅう、ジョニーさん
      member_ids = [6,7,8,10,11,12]
    end

    # refine_membersはmembers helperに定義
    @response_data = refine_members(member_ids)
    render json: @response_data
  end

end
