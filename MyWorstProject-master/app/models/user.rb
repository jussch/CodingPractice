class User < ActiveRecord::Base
  validates :username, :session_token, :password_digest, presence: true
  validates :password, length: { minimum: 5, allow_nil: true }

  has_many :comments, as: :commentable

  has_many :goals

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def self.find_by_credentials(username,password)
    user = User.find_by_username(username)
    return nil unless user && user.is_password?(password)
    user
  end

  after_initialize :ensure_session_token

  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
