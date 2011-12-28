class Facebook
  include HTTParty
  follow_redirects false
end

Trust.controllers :auth do
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
    account.name
  end

  get :failure, :map => '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env['omniauth.auth'])
  end
end
