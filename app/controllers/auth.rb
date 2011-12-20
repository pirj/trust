class Facebook
  include HTTParty
  follow_redirects false
end

Trust.controllers :auth do
  get :omniauth_callback, :map => '/auth/:provider/callback' do
    auth = request.env['omniauth.auth']
    account = Account.first(:uid => auth[:uid], :provider => params[:provider]) ||
      Account.create(:uid => auth[:uid], :provider => params[:provider],
      :name => auth[:info][:name], :avatar => auth[:info][:image], :role => :user)
    if account.name != auth[:info][:name] then
      account.name = auth[:info][:name]
      account.save
    end

    if account.uid == '1330077461' and account.role != :admin then
      account.role = :admin
      account.save
    end
    session[:facebook_auth_token] = auth[:credentials][:token]

    set_current_account(account)
    redirect '/'
  end
  
  get :callback do
    token = params[:token]
    uid = params[:uid]

    account = Account.first(:uid => uid)
    if account.nil? then
      user = MultiJson.decode HTTParty.get("https://graph.facebook.com/me?access_token=#{token}").body
      avatar = Facebook.get("https://graph.facebook.com/me/picture?access_token=#{token}&type=square").headers['location']
      account = Account.create(:uid => uid, :provider => 'facebook', :name => user['name'], :avatar => avatar, :role => :user)
    end

    if account.uid == '1330077461' and account.role != :admin then
      account.role = :admin
      account.save
    end
    session[:facebook_auth_token] = token

    set_current_account(account)
    redirect '/'
  end

  get :failure, :map => '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env['omniauth.auth'])
  end

  get :logout do
    set_current_account(nil)
    session[:no_auto_login] = true
    redirect '/'
  end
end
