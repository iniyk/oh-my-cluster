class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :passwd_md5
      t.integer :role
      t.integer :group
      t.text :info

      t.timestamps null: false
    end
  end
end
