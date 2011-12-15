Trust.controllers :auth do
  get :callback, :map => '/auth/:provider/callback' do
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

    set_current_account(account)

    redirect '/'
  end
  
  get :failure, :map => '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env['omniauth.auth'])
  end
end
