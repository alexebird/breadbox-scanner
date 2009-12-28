class CreateUsersTable < Sequel::Migration
  def up
    create_table :foods_users do
      Fixnum :food_id
      Fixnum :user_id
    end
  end

  def down
    drop_table :foods_users
  end
end
