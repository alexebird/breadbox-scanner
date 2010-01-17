require 'digest/sha2'

class User < Sequel::Model
  PASSWORD_SALT = 'SdFAjLkZsDGf7905Q34hJKXasFbbbbbbb'

  plugin :timestamps
  plugin :validation_helpers
  raise_on_save_failure = false

  one_to_many :scanners
  many_to_many :inventory, :class => 'Food', :right_key => :food_id
  one_to_many :foods_created, :class => 'Food', :key => :created_by_id

  def after_validation
    digest_password
  end

  def validate
    validates_unique :email, :username
    validates_presence [:name, :email, :username, :password]
    validates_format /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i, :email
    validates_format Regexp.compile('[A-Z0-9+=-_\*&\^%\$#@!?.,><]+', Regexp::IGNORECASE), :password
    validates_length_range 4..30, :username
  end

  def scan_food(food)
    if inventory.include? food
      remove_inventory(food)
    else
      add_inventory(food)
    end
  end

  private
  def digest_password
    self.password = User.digest_password(password)
  end

  class << self
    def digest_password(password)
      return password unless password
      digest = Digest::SHA2.new << (password + PASSWORD_SALT)
      digest.to_s
    end

    def find_login(username, password)
      User[:username => username, :password => User.digest_password(password)]
    end
  end
end
