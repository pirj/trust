class Rating
  include DataMapper::Resource
  property :id, Serial

  belongs_to :account, :key => true
  belongs_to :person, :key => true

  property :positive, Boolean

  property :deleted_at, ParanoidDateTime
  timestamps :at

  property :published, Boolean, :default => false
end
