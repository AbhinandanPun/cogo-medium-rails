class CreateRevisionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :revision_histories do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.string :action
      t.text :post_data

      t.timestamps
    end
  end
end
