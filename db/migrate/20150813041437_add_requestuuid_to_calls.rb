class AddRequestuuidToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :call1_request_uuid, :string
    add_column :calls, :call2_request_uuid, :string
  end
end
