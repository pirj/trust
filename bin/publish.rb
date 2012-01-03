#!/usr/bin/env ruby
#coding: utf-8
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

Padrino.after_load do
  DataMapper.finalize
end

Padrino.load!

def publish message, ratings, login
  # TODO: add vk publishing
  return if ratings.length == 0
  names = ratings.map do |r| r.person.name end
  if names.length > 3 then
    names = names[0..2].join(', ') + "и ещё #{names.length - 3} общественным деятелям"
  else
    names = names.join(', ')
  end
  post = "#{message} #{names} на Народном рейтинге"
  link = "http://grajdanin.org/person/view/#{ratings.first.person_id}"
  reply = HTTParty.post("https://graph.facebook.com/#{login.uid}/feed", :body => {:access_token => login.token, :message => post, :link => link})
  result = MultiJson.decode reply.body
  ratings.each do |r| r.published = true; r.save end if result['error'].nil?
  puts "error: #{result['error']}" unless result['error'].nil?
end

##
# Find all unpublished Ratings, get user tokens, and publish to wall
logins = Rating.all(:published.not => true).accounts.logins(:token.not => nil)

logins.each do |login|
  ratings = login.account.ratings(:published.not => true)
  positive = ratings.reject {|r| !r.positive}
  negative = ratings - positive
  publish("Я выразил доверие", positive, login)
  publish("Я выразил недоверие", negative, login)
end
