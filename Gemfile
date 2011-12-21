source :rubygems

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'slim'

%w(core postgres-adapter validations timestamps migrations constraints aggregates types pager is-tree).each do |g|
  gem 'dm-' + g
end

group :production do
  gem 'pg'
end

# Padrino Stable Gem
gem 'padrino', '0.10.5'
gem 'rack-protection'
gem 'padrino-cancan'

gem 'omniauth'
gem 'omniauth-facebook'
#gem 'omniauth-vkontakte'

gem 'httparty'

# Test requirements
gem 'rspec'
group :test do
  gem 'rack-test', :require => "rack/test"
end

group :development do
  gem 'thin'
end
