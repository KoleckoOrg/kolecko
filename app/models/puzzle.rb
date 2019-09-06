class Puzzle < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_many :hint_requests, dependent: :destroy
  has_many :solutions, dependent: :destroy
  has_many :answers, through: :visits, dependent: :destroy

  enum puztype: [:main, :secondary, :final]

  validates :solutions, presence: true
  validates :puztype, presence: true

  before_save do
    self.code.normalize!
  end

  def self.find_by_code(code)
    self.find_by(code: code.normalize)
  end

  def full_name
    name
  end
end
