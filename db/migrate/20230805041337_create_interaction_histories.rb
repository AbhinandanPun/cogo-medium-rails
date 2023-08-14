class CreateInteractionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :interaction_histories do |t|
        t.references :user, null: false, foreign_key: true, on_delete: :cascade
        t.references :post, null: false, foreign_key: true, on_delete: :cascade     
        t.string :interaction_type, null: false

        t.timestamps
      end
      add_index :interaction_histories, [:user_id, :post_id], unique: true
  end
end
