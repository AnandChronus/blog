class AddLftRgtParentIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :lft, :integer
    add_column :comments, :rgt, :integer
    add_column :comments, :parent_id, :integer
  end

  def self.down
    remove_column :comments, :parent_id
    remove_column :comments, :rgt
    remove_column :comments, :lft
  end
end
