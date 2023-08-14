class CreateShareLists < ActiveRecord::Migration[7.0]
  def change
    create_table :share_lists do |t|
      t.string :email_recipient
      t.references :user, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
