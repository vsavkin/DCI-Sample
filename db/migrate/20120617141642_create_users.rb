class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name

      t.string :address_country
      t.string :address_city
      t.string :address_postal_code
      t.string :address_street

      t.timestamps
    end
  end
end
