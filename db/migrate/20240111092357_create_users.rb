class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, limit: 80
      t.string :photo, limit: 255
      t.text :bio
      t.bigint :posts_counter

      t.timestamps
    end
  end
end
