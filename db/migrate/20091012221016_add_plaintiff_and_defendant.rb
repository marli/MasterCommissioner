class AddPlaintiffAndDefendant < ActiveRecord::Migration
  def self.up
    add_column :addresses, :plaintiff, :string
    add_column :addresses, :defendant, :string
  end

  def self.down
  end
end
