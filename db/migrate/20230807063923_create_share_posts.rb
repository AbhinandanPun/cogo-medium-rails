class CreateSharePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :share_posts do |t|
      t.string :email_recipient
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
