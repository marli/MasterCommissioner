class ChangeAddressTypeToCounty < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :type, :county
  end

  def self.down
    rename_column :addresses, :county, :type
  end
end
