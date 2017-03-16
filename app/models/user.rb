class User < ApplicationRecord
  after_initialize :ensure_session_token
  before_save :downcase_email_remove_whitespace
  validates :email, :team_name, :password_digest, :session_token, presence: true
  validates :email, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  has_many :entries
  has_many :tournaments, through: :entries
  has_many :picks, through: :entries
  has_many :rounds, through: :picks

  attr_reader :password

  def registered?(tournament)
    tournaments.include?(tournament)
  end

  def password=(password)
    @password = password.strip
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password.strip)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email.downcase.strip)
    return nil unless user

    if user.is_password?(password)
      user
    else
      nil
    end
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    save!
  end

  private
    def ensure_session_token
        self.session_token ||= SecureRandom.urlsafe_base64
    end

    def downcase_email_remove_whitespace
        self.email = self.email.downcase.strip unless self.email.nil?
    end
end
