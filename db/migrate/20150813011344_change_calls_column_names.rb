class ChangeCallsColumnNames < ActiveRecord::Migration
  def change
    rename_column :calls, :to_number, :to
    rename_column :calls, :from_number, :from
    rename_column :calls, :from_name, :name
  end
end
