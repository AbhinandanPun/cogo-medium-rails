class Draft < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def convert_to_post
    @post = Post.new(
      title: title,
      text: text,
      topic: topic,
      user: user
    )
  end
end
