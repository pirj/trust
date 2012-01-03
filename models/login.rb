class Login
  include DataMapper::Resource
  property :id, Serial

  belongs_to :account

  property :provider, String
  property :uid, String
  property :name, String
  property :avatar, String

  property :token, String

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
