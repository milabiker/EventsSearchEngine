class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :owner
      t.float :lat
      t.float :lon
      t.datetime :date
      t.float :attending

      t.timestamps
    end
  end
end
