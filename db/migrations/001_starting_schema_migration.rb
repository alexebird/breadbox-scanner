class CreateStartingSchema < Sequel::Migration
  def up
    create_table :foods do
      primary_key :id, :auto_increment => true, :null => false
      String :name
      String :major
      String :minor
      Fixnum :room_start 
      Fixnum :room_end
      Fixnum :fridge_start 
      Fixnum :fridge_end
      Fixnum :freezer_start 
      Fixnum :freezer_end
      String :rfid, :size => 10, :fixed => true
    end

    create_table :users do
      primary_key :id, :auto_increment => true, :null => false
      String :name
      String :email
    end

    create_table :scans do
      primary_key :id, :auto_increment => true, :null => false
      Fixnum :food_id
      Fixnum :scanner_id
      DateTime :timestamp
    end

    create_table :foods_users do
      Fixnum :food_id
      Fixnum :user_id
      Fixnum :scan_id
    end

    create_table :scanners do
      primary_key :id, :auto_increment => false, :null => false
      Fixnum :user_id
    end
  end

  def down
    drop_table :foods
    drop_table :users
    drop_table :scans
    drop_table :foods_users
  end
end
