class BalanceValidator < ActiveModel::Validator
  def validate(hint_request)
    if hint_request.bounty > hint_request.team.balance
      message = "Pro tuto akci nemáte dostatek bodů " \
                "(#{hint_request.team.balance_was} bodů k dispozici)"
      hint_request.errors.add(:base, message)
    end
  end
end

class HintRequest < ApplicationRecord
  belongs_to :team, autosave: true
  belongs_to :puzzle
  has_many :hints, dependent: :destroy

  validates_with BalanceValidator
end
