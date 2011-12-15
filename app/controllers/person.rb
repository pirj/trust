Trust.controllers :person do
  get :index, :map => '/' do
    authorize! :index, Person
    @people = Person.all(:moderated => true) + Person.all(:creator => current_account)
    render 'person/index'
  end

  get :new do
    authorize! :new, Person
    @person = Person.new
    render 'person/new'
  end

  get :newme do
    authorize! :newme, Person
    @person = Person.new :name => current_account.name, :photo => current_account.avatar
    render 'person/new'
  end

  post :create do
    authorize! :create, Person
    @person = Person.new params[:person]
    @person.photo = CGI.unescapeHTML @person.photo
    @person.creator = current_account
    logger.error @person
    if @person.save
      logger.error @person.errors
      flash[:notice] = "Saved and on moderation"
      redirect url(:person, :index)
    else
      flash[:error] = "Not saved"
      render 'person/new'
    end
  end

  get :view, :with => :person_id do
    authorize! :view, Person
    @person = Person.get params[:person_id]
    halt 404 if @person.nil?
    render 'person/view'
  end

  get :edit, :with => :person_id do
    authorize! :edit, Person

  end

  post :update, :with => :person_id do
    authorize! :update, Person

  end

  post :approve, :with => :person_id do
    authorize! :approve, Person

  end

  post :reject, :with => :person_id do
    authorize! :reject, Person

  end
end
