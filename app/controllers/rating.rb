Trust.controllers :rating do
  post :plus, :with => :person_id do
    authorize! :plus, Rating
    person = Person.get params[:person_id]
    halt 404 if person.nil?
    rating = Rating.first(:person => person, :account => current_account) ||
        Rating.new(:person => person, :account => current_account)
    rating.positive = true
    rating.save
    person.total = person.rating
    person.save
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
    person.total = person.rating
    person.save
    content_type 'text/plain'
    person.total.to_s
  end
end
