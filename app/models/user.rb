class User < ApplicationRecord
  # validates is a var(?), name is a symbol and presence is a key
  validates :name, presence: true, length: {maximum: 50}
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # allows foo@bar..com
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # enfore email presence, email format, email length maximum and email uniqueness - although uniqueness DOES NOT work at the db level. Think one user double clicking save (you've done that yourself, it happens, solution: add index on email column in migration and require that index be unique) - create a new migration and add the index to users emails
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # case sensitive false means that FOOBAR@EMAIL.COM == foobar@email.com

  # >> %w[foo bar baz]
  # => ["foo", "bar", "baz"]


end
