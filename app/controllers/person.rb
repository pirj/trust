Trust.controllers :person do
  get :index, :map => '/' do
    authorize! :index, Person

    @people = Person.all(:moderated => false, :creator => current_account) +
      Person.all(:moderated => true, :order => [ :total.desc ])
    name = params[:query]
    @people = @people & Person.all(:conditions => ["name ILIKE ?", "%#{name}%"]) unless name.nil?

    @votes = Hash[*Rating.all(:account => current_account, :person => @people).map do |rating|
      [rating.person, rating.positive]
    end.flatten]
    if request.xhr?
      partial 'person/table'
    else
      render 'person/index'
    end
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
    if @person.save
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

  get :suspicious do
    authorize! :approve, Person

    @people = Person.all(:moderated => false, :order => [ :updated_at.asc ])
    render 'person/shortindex'
  end

  post :approve, :with => :person_id do
    authorize! :approve, Person

    @person = Person.get params[:person_id]
    halt 404 if @person.nil?
    @person.moderated = true
    @person.save
    redirect url(:person, :view, @person.id)
  end

  post :reject, :with => :person_id do
    authorize! :reject, Person

    @person = Person.get params[:person_id]
    halt 404 if @person.nil?
    @person.moderated = false
    @person.save
    redirect url(:person, :view, @person.id)
  end

  post :delete, :with => :person_id do
    authorize! :delete, Person

    @person = Person.get params[:person_id]
    halt 404 if @person.nil?
    @person.destroy
    redirect url(:person, :suspicious)
  end
end
