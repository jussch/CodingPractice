class User < ActiveRecord::Base
  validates :name, :password_digest, :session_token, presence: true
  validates :name, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  has_many :comments,
  class_name: "User",
  foreign_key: :author_id,
  primary_key: :id

  has_many :subs,
  class_name: "User",
  foreign_key: :moderator_id,
  primary_key: :id


  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def self.find_by_credentials(name, password)
    user = User.find_by_name(name)
    return nil unless user && user.is_password?(password)
    user
  end

  attr_reader :password

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

end
