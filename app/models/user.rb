class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :notes, foreign_key: :author_id, dependent: :destroy, inverse_of: :author
  has_many :follows, dependent: :destroy
  has_many :followed_trails, through: :follows, source: :trail

  validates :name, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
