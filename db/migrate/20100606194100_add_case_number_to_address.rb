class AddCaseNumberToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :case_number, :string
  end

  def self.down
    remove_column :addresses, :case_number
  end
end
