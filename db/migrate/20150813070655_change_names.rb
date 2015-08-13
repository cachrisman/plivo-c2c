class ChangeNames < ActiveRecord::Migration
  def change
    rename_column :calls, :to, :To
    rename_column :calls, :from, :From
  end
end
