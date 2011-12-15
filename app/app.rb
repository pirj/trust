#coding: UTF-8
class Trust < Padrino::Application
#  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl
  register Padrino::CanCan

  enable :sessions
#  set :sessions, true
  set :login_page, "/auth/facebook"
  enable :store_location
  enable :authentication
  use OmniAuth::Builder do
#    provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET']
    provider :facebook, '273684999345723', '1f0cd672ea60ef13aa5f21de219c56ce'
    #, :scope => 'email,offline_access,read_stream', :display => 'popup'
    # TODO: request specific facebook permissions (scope) http://developers.facebook.com/docs/reference/api/permissions/
    # TODO: tune auth dialog type http://developers.facebook.com/docs/reference/dialogs#display
  end

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
