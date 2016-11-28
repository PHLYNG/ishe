class User < ApplicationRecord

  validate :has_password

  # user associations
  has_many :user_join_projects
  has_many :projects, through: :user_join_projects

  # ensures compatability with database adapters that use case-sensitive indices
  before_save { self.email = email.downcase }
  # could shorten to self.email = email.downcase to email.downcase!

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

  # validate photo attachments, req for paperclip
  validates :photo, attachment_presence: true
  validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :photo, :less_than => 10.megabytes
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  # determines what to grab from auth_hash
  # and then uses that info to login/create a User
  def self.from_omniauth(auth_hash)
    # twitter requires a privacy policy url
    # and a ToS url before including email
    # with auth_hash
    # https://dev.twitter.com/rest/reference/get/account/verify_credentials
    user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    user.name = auth_hash['info']['name']
    if auth_hash.provider == "twitter"
      # for twitter logins, just generate
      # random number for now
      user.photo = auth_hash['info']['image']
      number = rand(1...1000)
      user.email = "dave#{number}@example.com"
    else
      # if auth_hash.provider == "facebook"
      # send facebook photo through
      # process_uri for http -> https
      user.photo = process_uri(auth_hash['info']['image'])
      user.email = auth_hash['info']['email']
    end
    user.motto = "I'm a user"
    user.save!
    user
  end

  def has_password
    if self.provider == nil
      # validates :password_confirmation, presence: true, length: {minimum: 6}
      if !has_secure_password && !password.present?
        errors.add(:password, "Password is either not secure or not present")
      end
    end
    # has_secure_password
    # validates :password, presence: true, length: {minimum: 6}
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

   BCrypt::Password.create(string, cost: cost)
  end

 private

 # facebook's image login is weird
 # needed to use this + open_uri_redirections gem
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
