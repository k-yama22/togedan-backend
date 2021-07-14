class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :event_name
      t.string :genre
      t.string :location
      t.date :event_date
      t.time :start_time
      t.time :end_time
      t.text :event_message
      t.integer :max_people
      t.string :event_sts

      t.timestamps
    end
  end
end
