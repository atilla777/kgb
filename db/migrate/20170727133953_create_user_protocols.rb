class CreateUserProtocols < ActiveRecord::Migration
  def change
    create_table :user_protocols do |t|
      t.references :user, index: true, foreign_key: true
      t.string :ip_address
      t.string :action
      t.string :controller
      t.string :description

      t.timestamps null: false
    end
    add_index :user_protocols, :ip_adress
    add_index :user_protocols, :action
    add_index :user_protocols, :controller
  end
end
