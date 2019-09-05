class BalanceValidator < ActiveModel::Validator
  def validate(record)
    if record.team.points < 0
      message = "Pro tuto akci nemáte dostatek bodů " \
                "(#{record.team.points_was} bodů k dispozici)"
      record.errors.add(:base, message)
    end
  end
end

class CancelValidator < ActiveModel::Validator
  def validate(record)
    has_opened_hints = record.hints.where(opened: true).exists?
    if record.cancelled_changed? && record.cancelled && has_opened_hints
      message = "Tuto žádost o nápovědu už není možné zrušit"
      record.errors.add(:base, message)
    end
  end
end

class HintRequest < ApplicationRecord
  belongs_to :visit
  has_one :team, through: :visit, autosave: true
  has_one :puzzle, through: :visit
  has_many :hints, dependent: :destroy

  validates_with BalanceValidator, CancelValidator

# this is probably something I don't want
#  before_save do
#    self.closed = true if self.cancelled?
#  end

end
