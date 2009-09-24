class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :webaddress
      t.string :parse_info

      t.timestamps
    end
  end

  def self.down
    drop_table :websites
  end
end
