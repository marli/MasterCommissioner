class AddAppraisalToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :appraised_value, :string
    add_column :addresses, :amount_due, :string
    add_column :addresses, :sale_date, :string
    add_column :addresses, :cancelled, :boolean
    add_column :addresses, :winner, :string
    add_column :addresses, :winning_bid, :string
  end

  def self.down
  end
end
