# coding: utf-8
class User
  include Mongoid::Document
  include Redis::Search


  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # fields
  field :name
  key :name

  field :website
  field :signature

  field :posts_count, :type => Integer, :default => 0
  field :comments_count, :type => Integer, :default => 0

  validates :name, :length => {:in => 3..20}, :presence => true #, :uniqueness => {:case_sensitive => true}

  scope :hot, desc(:comments_count, :posts_count)

  # References
  has_many :posts
  has_many :comments

  field :node_ids, :type => Array, :default => []


  # Redis Search
  redis_search_index(:title_field => :name,
                     :score_field => :posts_count,
                     :ext_field => :email)

  def following?(node_id)
    node = Node.find(node_id)
    node.follower_ids.include?(self.id)
  end


  def admin?
    APP_CONFIG['admin_emails'].include? self.email
  end

end
