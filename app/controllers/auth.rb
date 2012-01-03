class NoRedirects
  include HTTParty
  follow_redirects false
end

Trust.controllers :auth do
  # TODO: when a user log in with additional login and account exists, glue accounts
  get :facebook do
    token = params[:token]
    uid = params[:uid]

    login = Login.first(:uid => uid, :provider => 'facebook')
    if login.nil? then
      user = MultiJson.decode HTTParty.get("https://graph.facebook.com/me?access_token=#{token}").body
      avatar = NoRedirects.get("https://graph.facebook.com/me/picture?access_token=#{token}&type=square").headers['location']
      logger.error "fb current_account = #{current_account}"
      account = current_account || Account.create(:role => :user)
      logger.error "fb account = #{account}"
      login = Login.create(:account => account, :uid => uid, :provider => 'facebook', :name => user['name'], :avatar => avatar)
    end

    if login.uid == '1330077461' and login.account.role != :admin then
      login.account.role = :admin
      login.account.save
    end

    session[:facebook_auth_token] = token
    login.token = token
    login.save

    set_current_account(login.account)
    login.name
  end

  get :vk do
    sig = params[:sig]
    uid = params[:uid]
    name = params[:name]

    login = Login.first(:uid => uid, :provider => 'vk')
    if login.nil? then
      logger.error "vk current_account = #{current_account}"
      account = current_account || Account.create(:role => :user)
      logger.error "vk account = #{account}"
      login = Login.create(:account => account, :uid => uid, :provider => 'vk', :name => name, :avatar => '')
    end

    if login.uid == '914148' and login.account.role != :admin then
      login.account.role = :admin
      login.account.save
    end
    session[:vk_auth_sig] = sig

    set_current_account(login.account)
    login.name
  end
end
