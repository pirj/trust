class NoRedirects
  include HTTParty
  follow_redirects false
end

Trust.controllers :auth do
  get :facebook do
    logger.error params[:token]
    token = params[:token]
    uid = params[:uid]

    account = Account.first(:uid => uid, :provider => 'facebook')
    if account.nil? then
      user = MultiJson.decode HTTParty.get("https://graph.facebook.com/me?access_token=#{token}").body
      avatar = NoRedirects.get("https://graph.facebook.com/me/picture?access_token=#{token}&type=square").headers['location']
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

  get :vk do
    sig = params[:sig]
    uid = params[:uid]

    account = Account.first(:uid => uid, :provider => 'vk')
    if account.nil? then
      account = Account.create(:uid => uid, :provider => 'vk', :name => 'name', :avatar => '', :role => :user)
    end

    if account.uid == '914148' and account.role != :admin then
      account.role = :admin
      account.save
    end
    session[:vk_auth_sig] = sig

    #set_current_account(account)
    'ok'
  end
end
