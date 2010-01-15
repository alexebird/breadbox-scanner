class CreateStartingSchema < Sequel::Migration
  def up
    create_table :foods do
      primary_key :id, :auto_increment => true, :null => false
      String :name
      String :major
      String :minor
      Fixnum :room
      Fixnum :fridge
      Fixnum :freezer
      String :rfid, :size => 10, :fixed => true
      Fixnum :created_by_id, :default => nil
      DateTime :created_at
      DateTime :updated_at
    end

    create_table :users do
      primary_key :id, :auto_increment => true, :null => false
      String :username
      String :password
      String :name
      String :email
      DateTime :created_at
      DateTime :updated_at
    end

    create_table :foods_users do
      Fixnum :food_id
      Fixnum :user_id
    end

    create_table :scans do
      primary_key :id, :auto_increment => true, :null => false
      Fixnum :food_id
      Fixnum :scanner_id
      Fixnum :location
      DateTime :timestamp
    end

    create_table :scanners do
      primary_key :id, :auto_increment => false, :null => false
      Fixnum :user_id
      DateTime :created_at
      DateTime :updated_at
    end
  end

  def down
    drop_table :foods
    drop_table :users
    drop_table :foods_users
    drop_table :scans
    drop_table :scanners
  end
end
