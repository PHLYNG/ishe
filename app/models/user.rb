class User < ApplicationRecord

  validate :has_password

  # user associations
  has_many :user_join_projects
  has_many :projects, through: :user_join_projects

  # ensures compatability with database adapters that use case-sensitive indices
  before_save { self.email = email.downcase }
  # could shorten to self.email = email.downcase to email.downcase!

  def self.from_omniauth(auth_hash)
    binding.pry
    user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    user.name = auth_hash['info']['name']
    unless auth_hash.provider == "facebook"
      user.photo = auth_hash['info']['image']
      user.email = "dave2@example.com"
    else
      user.photo = process_uri(auth_hash['info']['image'])
      user.email = auth_hash['info']['email']
    end
    user.motto = "I'm a user"
    user.save!
    user
  end



  validates :motto, length: { maximum: 255 }

  has_attached_file :photo,
  styles: { medium: "200x200>", thumb: "100x100>" },
  :url => "/system/:class/:attachment/:id_partition/:style/:filename",
  :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename"

  # validates is a var(?), name is a symbol and presence is a key
  validates :name, presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # allows foo@bar..com
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # enfore email presence, email format, email length maximum and email uniqueness - although uniqueness DOES NOT work at the db level. Think one user double clicking save (you've done that yourself, it happens, solution: add index on email column in migration and require that index be unique) - create a new migration and add the index to users emails
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # case sensitive false means that FOOBAR@EMAIL.COM == foobar@email.com

  def has_password
    if self.provider == nil
      if !has_secure_password && !password.present?
        errors.add(:password, "Password is either not secure or not present")
      end
    end
    # has_secure_password
    # validates :password, presence: true, length: {minimum: 6}
  end

  # validates :password_confirmation, presence: true, length: {minimum: 6}

  # Returns the hash digest of the given string.
 def User.digest(string)
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

   BCrypt::Password.create(string, cost: cost)
 end

# validate photo attachments, req for paperclip
 validates :photo, attachment_presence: true
 validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/]
 validates_attachment_size :photo, :less_than => 10.megabytes
 validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

 private

 def self.process_uri(uri)
   require 'open-uri'
   require 'open_uri_redirections'
   open(uri, :allow_redirections => :safe) do |r|
     r.base_uri.to_s
   end
 end

  # >> %w[foo bar baz]
  # => ["foo", "bar", "baz"]

end
