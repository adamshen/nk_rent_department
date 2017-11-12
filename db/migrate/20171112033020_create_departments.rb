class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string :address
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
