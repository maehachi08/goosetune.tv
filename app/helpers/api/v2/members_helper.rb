module Api::V2::MembersHelper
  def refine_members(member_ids)
    @member_ids = []
    member_ids.group_by { |id| @member_ids.push(id.to_i) }

    refine_members = Member.get_members(member_ids)
    not_refine_members = Member.get_unrefine_members(member_ids)
    members = Member.get_all
    entries = Member.get_youtubes_with_refine_members(refine_members)
    resources_with_pagination( Kaminari.paginate_array(entries).page(params[:page]) )

    {
      'contents': {
        'youtubes'           => entries,
        'members'            => members,
        'not_refine_members' => not_refine_members,
        'refine_members'     => refine_members,
      },
      'common'             => @common_data
    }
  end
end
