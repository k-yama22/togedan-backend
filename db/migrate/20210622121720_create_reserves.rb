class CreateReserves < ActiveRecord::Migration[6.1]
  def change
    create_table :reserves do |t|
      t.integer :event_id
      t.integer :user_id
      t.string :reserve_sts

      t.timestamps
    end
  end
end
