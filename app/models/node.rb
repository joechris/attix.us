class Node
  include Mongoid::Document

  # Fields:
  field :title
  field :posts_count, :type => Integer, :default => 0

  # References
  references_many :posts

  # Validation
  validates_presence_of :title
  validates_uniqueness_of :title
end
