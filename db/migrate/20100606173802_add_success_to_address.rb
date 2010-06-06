class AddSuccessToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :success, :boolean, :default => false
  end

  def self.down
    remove_column :addresses, :success
  end
end
