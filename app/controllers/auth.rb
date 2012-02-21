class NoRedirects
  include HTTParty
  follow_redirects false
end

Trust.controllers :auth do
  # TODO: when a user log in with additional login and account exists, glue accounts
  get :facebook do
    token = params[:token]

    user = MultiJson.decode HTTParty.get("https://graph.facebook.com/me?access_token=#{token}").body
    uid = user['id'] 
    halt 403 if uid.nil?
    login = Login.first(:uid => uid, :provider => 'facebook')
    if login.nil? then
      avatar = NoRedirects.get("https://graph.facebook.com/me/picture?access_token=#{token}&type=square").headers['location']
      account = current_account || Account.create(:role => :user)
      login = Login.create(:account => account, :uid => uid, :provider => 'facebook', :name => user['name'], :avatar => avatar)
    end

    if login.uid == ENV['ADMIN_FB_ID'] and login.account.role != :admin then
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
    data = JSON.parse CGI.unescape_html params[:params]
    sig = Digest::MD5.hexdigest ['expire', 'mid', 'secret', 'sid'].map { |p| "#{p}=#{data[p]}" }.push(ENV['VK_SECRET']).join
    
    halt 403 unless sig == data['sig']
    uid = data['mid']
    name = "#{data['first_name']} #{data['last_name']}"
    login = Login.first(:uid => uid, :provider => 'vk')
    if login.nil? then
      account = current_account || Account.create(:role => :user)
      login = Login.create(:account => account, :uid => uid, :provider => 'vk', :name => name, :avatar => '')
    end

    if login.uid == ENV['ADMIN_VK_ID'] and login.account.role != :admin then
      login.account.role = :admin
      login.account.save
    end
    session[:vk_auth_token] = token
    login.token = token
    login.save

    set_current_account(login.account)
    name
  end
end

