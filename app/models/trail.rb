class Trail < ApplicationRecord
  has_many :notes, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :followers, through: :follows, source: :user

  validates :name, presence: true
end
