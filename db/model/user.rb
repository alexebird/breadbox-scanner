require 'digest/sha2'

class User < Sequel::Model
  PASSWORD_SALT = 'SdFAjLkZsDGf7905Q34hJKXasFbbbbbbb'

  plugin :timestamps
  plugin :validation_helpers

  one_to_many :scanners
  many_to_many :foods
  User.raise_on_save_failure = false

  def after_validate
    password = digest_password(password)
  end

  def validate
    validates_unique :email, :username
    validates_presence [:name, :email, :username, :password]
    validates_format /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i, :email
    validates_format Regexp.compile('[A-Z0-9+=-_\*&\^%\$#@!?.,><]+', Regexp::IGNORECASE), :password
    validates_length_range 4..30, :username
  end

  def self.digest_password(password)
    digest = Digest::SHA2.new << (password + PASSWORD_SALT)
    digest.to_s
  end

  def self.find_login(username, password)
    User[:username => username, :password => digest_password(password)]
  end

  def scan_food(food)
    if foods.include? food
      remove_food(food)
    else
      add_food(food)
    end
  end
end
