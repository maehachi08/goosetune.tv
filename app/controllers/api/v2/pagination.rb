module Api::V2::Pagination
  def resources_with_pagination(resources)
    response.set_header('X-Total-Pages', resources.total_pages)
    response.set_header('X-Per-Page', resources.limit_value)
    response.set_header('X-Offset', resources.offset_value)
    response.set_header('X-Next-Page', resources.next_page)
    response.set_header('X-Total', resources.total_count)
    response.set_header('X-Page', resources.current_page)
    response.set_header('X-Prev-Page', resources.prev_page)
  end
end
