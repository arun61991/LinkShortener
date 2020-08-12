class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :slug
      t.integer :clicked, default: 0
      t.string :countries
      t.string :ip_addresses

      t.timestamps
    end
  end
end
