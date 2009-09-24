class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street_line_1
      t.string :stree_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :lat
      t.string :long

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
