class User < ApplicationRecord
  has_secure_password

  has_many :projects, dependent: :destroy

  # Role enum: 0 = user (default), 1 = admin
  enum :role, { user: 0, admin: 1 }, default: :user

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  before_save :downcase_username

  # Role helper methods
  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  private

  def downcase_username
    self.username = username.downcase
  end
end
