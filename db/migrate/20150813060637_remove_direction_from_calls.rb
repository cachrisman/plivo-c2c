class RemoveDirectionFromCalls < ActiveRecord::Migration
  def change
    remove_column :calls, :Direction, :string
    remove_column :calls, :ALegUUID, :string
    remove_column :calls, :ALegRequestUUID, :string
    remove_column :calls, :call1_request_uuid, :string
    remove_column :calls, :call2_request_uuid, :string
    add_column :calls, :request_uuids, :text
  end
end
