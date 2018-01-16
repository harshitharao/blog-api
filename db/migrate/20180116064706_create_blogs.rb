class CreateBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :published_date
      t.string :description
      t.string :content
      t.string :link

      t.timestamps
    end
  end
end
