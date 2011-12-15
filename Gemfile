source :rubygems

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'bcrypt-ruby', :require => "bcrypt"
#gem 'sass'
gem 'slim'

%w(core validations timestamps migrations constraints aggregates types pager is-tree).each do |g|
  gem 'dm-' + g
end

# gem 'do_postgres'
group :production do
 gem 'pg'
 gem 'dm-postgres-adapter'
end

# Padrino Stable Gem
gem 'padrino', '0.10.5'
gem 'rack-protection'
gem 'padrino-cancan'
#gem 'cancan'

gem 'omniauth'
gem 'omniauth-facebook'
#gem 'omniauth-vkontakte'

# Test requirements
gem 'rspec'
group :test do
  gem 'rack-test', :require => "rack/test"
end

group :development do
  gem 'dm-sqlite-adapter'
  gem 'thin'
end
