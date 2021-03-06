#coding: UTF-8
class Trust < Padrino::Application
#  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl
  register Padrino::CanCan
  register Sinatra::Flash

  use Rack::Session::Pool
  enable :authentication
  use Rack::Protection
  disable :asset_stamp

  error CanCan::AccessDenied do
    403
  end
  
  error do
    'Произошло нечто ужасное ' + env['sinatra.error'].name
  end

  [403, 404, 405, 500].each do |code|
    error code do
      render "errors/#{code}" #, :layout => 'errors/layout'
    end
  end

  [:admin, :moderator, :user].each do |role|
    access_control.roles_for role do |void| end
  end

  role [:any, :admin, :moderator, :user] do
    can [:index, :view], Person
  end
    
  role [:admin, :moderator, :user] do
    can [:new, :newme, :create], Person
    can [:plus, :minus], Rating
  end

  role [:admin, :moderator] do
    can [:edit, :update, :approve, :reject], Person
  end

  role [:admin] do
    can :delete, Person
    can [:index, :view, :block, :unblock], Account
  end

  DataMapper::Pagination.defaults[:previous_text] = '←'
  DataMapper::Pagination.defaults[:next_text] = '→'
  DataMapper::Pagination.defaults[:first_text] = '⇤'
  DataMapper::Pagination.defaults[:last_text] = '⇥'
  DataMapper::Pagination.defaults[:per_page] = 15
end
