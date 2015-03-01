class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :time
      t.string :location
      t.string :link

      t.timestamps null: false
    end
  end
end
