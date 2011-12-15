class Rating
  include DataMapper::Resource
  property :id, Serial

  belongs_to :account, :key => true
  belongs_to :person, :key => true

  property :positive, Boolean
end
