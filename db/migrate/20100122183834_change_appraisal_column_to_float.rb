class ChangeAppraisalColumnToFloat < ActiveRecord::Migration
  def self.up
    change_column :addresses, :appraised_value, :float
  end

  def self.down
  end
end
