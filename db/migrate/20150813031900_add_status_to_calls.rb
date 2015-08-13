class AddStatusToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :CallUUID, :string
    add_column :calls, :CallStatus, :string
    add_column :calls, :Direction, :string
    add_column :calls, :ALegUUID, :string
    add_column :calls, :ALegRequestUUID, :string
  end
end


