class User < ApplicationRecord
    has_secure_password
    has_many :posts
    has_many :drafts, dependent: :destroy
    has_many :views
    has_many :likes
    has_many :comments 
    has_many :interaction_histories, dependent: :destroy
    # User can have many followers
    has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Following', dependent: :destroy
    has_many :followers, through: :follower_relationships, source: :follower
  
    # User can follow many other users
    has_many :following_relationships, foreign_key: :follower_id, class_name: 'Following', dependent: :destroy
    has_many :following, through: :following_relationships, source: :followed
end

