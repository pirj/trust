#coding: utf-8
Trust.controllers :person do
  get :index, :map => '/' do
    authorize! :index, Person

    @people = Person.all(:name.like => "%#{params[:query]}%", :moderated => false, :creator => current_account) +
      Person.all(:name.like => "%#{params[:query]}%", :moderated => true, :order => [ :total.desc ])

    @votes = Hash[*Rating.all(:account => current_account, :person => @people).map do |rating|
      [rating.person, rating.positive]
    end.flatten]
    if request.xhr?
      partial 'person/table'
    else
      render 'person/index'
    end
  end

  post :create do
    authorize! :create, Person
    person = params[:person]
    @person = Person.new(:name => person[:name], :bio => person[:bio], :photo => CGI.unescapeHTML(person[:photo]))
    @person.creator = current_account
    if @person.save
      @votes = {}
      partial 'person/row', :locals => {:person => @person, :yellow => 'yellow'}
    else
      halt 401, 'Ошибка сохранения'
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
