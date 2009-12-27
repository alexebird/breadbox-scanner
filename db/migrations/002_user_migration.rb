class CreateUsersTable < Sequel::Migration
  def up
    create_table :users do
      primary_key :id, :auto_increment => true, :null => false
      String :name
      String :email
    end

    alter_table :foods do
      add_column :user_id, Fixnum
    end
  end

  def down
    drop_table :users
    alter_table :foods do
      drop_column :user_id
    end
  end
end
