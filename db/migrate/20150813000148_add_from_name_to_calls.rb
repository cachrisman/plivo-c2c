class AddFromNameToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :from_name, :string
    rename_column :calls, :from, :from_number
    rename_column :calls, :to, :to_number
    drop_table :click_to_calls
  end
end
