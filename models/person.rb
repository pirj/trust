class Person
  include DataMapper::Resource
  property :id, Serial

  validates_presence_of :name, :bio

  property :name, String
  property :bio, String
  property :photo, String, :length => 256
  property :moderated, Boolean, :default => false

  has n, :ratings
  belongs_to :creator, 'Account'

  property :total, Integer, :default => 0

  def rating
    ratings(:positive => true).count - ratings(:positive => false).count
  end
end
