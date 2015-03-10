class AddEventdayToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :event_day, :integer
  end
end
