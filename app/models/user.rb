class User < ApplicationRecord
    has_secure_password
    has_many :posts
    has_many :drafts
    has_many :views
    has_many :likes
    has_many :comments
    has_many :interaction_histories
    has_many :revision_histories
    has_many :subscriptions
    # User can have many followers
    has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Following'
    has_many :followers, through: :follower_relationships, source: :follower
  
    # User can follow many other users
    has_many :following_relationships, foreign_key: :follower_id, class_name: 'Following'
    has_many :following, through: :following_relationships, source: :followed
end

