class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :to
      t.string :from

      t.timestamps null: false
    end
  end
end
