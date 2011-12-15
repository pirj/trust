source :rubygems

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'bcrypt-ruby', :require => "bcrypt"
#gem 'sass'
gem 'slim'

%w(core sqlite-adapter postgres-adapter validations timestamps migrations constraints aggregates types pager is-tree).each do |g|
  gem 'dm-' + g
end

# gem 'do_postgres'

# Padrino Stable Gem
gem 'padrino', '0.10.5'
gem 'rack-protection'
gem 'padrino-cancan'
#gem 'cancan'

gem 'omniauth'
gem 'omniauth-facebook'
#gem 'omniauth-vkontakte'

# Test requirements
group :test do
  gem 'rspec', :group => "test"
  gem 'rack-test', :require => "rack/test", :group => "test"
end

group :development do
  gem 'thin'
end