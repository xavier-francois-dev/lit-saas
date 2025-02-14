class CreateApiUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :api_users do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
