class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :url
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
