class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :twitter_id, null: false
      t.string :nickname
      t.string :name
      t.string :token
      t.string :refresh_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
