class Account
  include DataMapper::Resource
  property :id, Serial
  property :role, String

  property :provider, String
  property :uid, String
  property :name, String
  property :avatar, String

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    get(id) rescue nil
  end

  has n, :ratings
end
