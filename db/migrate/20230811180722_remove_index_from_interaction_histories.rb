class RemoveIndexFromInteractionHistories < ActiveRecord::Migration[7.0]
  def change
    remove_index :interaction_histories, name: "index_interaction_histories_on_user_id_and_post_id"
    add_index :interaction_histories, [:user_id, :post_id, :interaction_type], name: "index_interaction_histories", unique: true
  end
end
