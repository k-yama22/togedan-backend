class CreateReserves < ActiveRecord::Migration[6.1]
  def change
    create_table :reserves do |t|
      t.string :event_id
      t.string :user_id
      t.string :reserve_sts

      t.timestamps
    end
  end
end
