class AddDeletedParentToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :deleted_parent, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :deleted_parent
  end
end
