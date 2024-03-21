class CreateUserTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tokens do |t|
      t.string :access_token, index: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
