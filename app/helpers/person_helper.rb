Trust.helpers do
  def render_index
    @votes = Hash[*Rating.all(:account => current_account, :person => @people).map do |rating|
      [rating.person, rating.positive]
    end.flatten]
    if request.xhr?
      partial 'person/table'
    else
      render 'person/index'
    end
  end
end
