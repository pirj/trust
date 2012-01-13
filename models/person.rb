class Person
  include DataMapper::Resource
  property :id, Serial

  validates_presence_of :name, :bio

  property :name, Text, :unique => true
  property :bio, Text
  property :photo, Text
  property :moderated, Boolean, :default => false

  has n, :ratings
  belongs_to :creator, 'Account'

  property :total, Integer, :default => 0
  property :positive, Integer, :default => 0
  property :negative, Integer, :default => 0
  property :overall, Integer, :default => 0

  property :deleted_at, ParanoidDateTime
  timestamps :at
end
