class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.string :blog_id
      t.string :user_id

      t.timestamps
    end
  end
end
