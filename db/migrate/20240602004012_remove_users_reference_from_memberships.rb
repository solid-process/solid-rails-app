class RemoveUsersReferenceFromMemberships < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :uuid, :string

    add_index :users, :uuid, unique: true

    create_table :account_members do |t|
      t.string :uuid, null: false, index: {unique: true}

      t.timestamps
    end

    add_column :memberships, :member_id, :bigint

    reversible do |dir|
      dir.up do
        User::Record.find_each do |user|
          user.update!(uuid: ::UUID.generate)

          member = Account::Member::Record.create!(uuid: user.uuid)

          Account::Membership::Record.where(user_id: user.id).update_all(member_id: member.id)
        end
      end
    end

    change_column_null :users, :uuid, false

    add_foreign_key :memberships, :account_members, column: :member_id

    change_column_null :memberships, :member_id, false

    remove_reference :memberships, :user, foreign_key: true
  end
end
