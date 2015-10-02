module TasksHelper

  def filter_active?(filter)
    request.original_url.include?(filter)
  end
end
