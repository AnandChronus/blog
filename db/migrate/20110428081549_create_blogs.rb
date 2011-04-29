class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
