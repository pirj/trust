#coding: utf-8
Trust.controllers :rating do
  post :plus, :with => :person_id do
    authorize! :plus, Rating
    person = Person.get params[:person_id]
    halt 404 if person.nil?
    rating = Rating.first(:person => person, :account => current_account) ||
        Rating.new(:person => person, :account => current_account)
    rating.positive = true
    rating.save
    recalculate person

    content_type 'text/plain'
    person.total.to_s
  end

  post :minus, :with => :person_id do
    authorize! :minus, Rating
    person = Person.get params[:person_id]
    halt 404 if person.nil?
    rating = Rating.first(:person => person, :account => current_account) ||
        Rating.new(:person => person, :account => current_account)
    rating.positive = false
    rating.save
    recalculate person

    content_type 'text/plain'
    person.total.to_s
  end

  get :my do
    @title = "Мои действия"
    @ratings = aggregate current_account.ratings.page(0, :per_page => 5)
    render 'rating/table', :layout => false
  end

  get :recommendations do
    @title = "Единомышленники"
    @ratings = []
    render 'rating/table', :layout => false
  end

  get :friends do
    @title = "Друзья"
    # TODO: turn off pagination/or fetch all pages
    friends = MultiJson.decode HTTParty.get("https://graph.facebook.com/me/friends?access_token=#{session[:facebook_auth_token]}").body
    friend_ids = friends.first[1].map { |friend| friend['id'] }
    @ratings = aggregate Account.all(:uid => friend_ids).ratings

    render 'rating/table', :layout => false
  end

  get :feed do
    @title = "Прямо сейчас"
    @ratings = aggregate Rating.all(:order => [:updated_at]).page(0, :per_page => 20)
    render 'rating/table', :layout => false
  end
end
