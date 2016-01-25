class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.string :address
      t.string :user
      t.text :id_rsa
      t.text :id_rsa_pub
      t.text :info

      t.timestamps null: false
    end
  end
end
