class User < ApplicationRecord

  # user associations
  has_many :user_join_projects
  has_many :projects, through: :user_join_projects

  # ensures compatability with database adapters that use case-sensitive indices
  before_save { self.email = email.downcase }
  # could shorten to self.email = email.downcase to email.downcase!

  # validates is a var(?), name is a symbol and presence is a key
  validates :name, presence: true, length: {maximum: 50}
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # allows foo@bar..com
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # enfore email presence, email format, email length maximum and email uniqueness - although uniqueness DOES NOT work at the db level. Think one user double clicking save (you've done that yourself, it happens, solution: add index on email column in migration and require that index be unique) - create a new migration and add the index to users emails
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # case sensitive false means that FOOBAR@EMAIL.COM == foobar@email.com

  # change this in production to min 9
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # validates :password_confirmation, presence: true, length: {minimum: 6}

  # Returns the hash digest of the given string.
 def User.digest(string)
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

   BCrypt::Password.create(string, cost: cost)
 end


  # >> %w[foo bar baz]
  # => ["foo", "bar", "baz"]

end
