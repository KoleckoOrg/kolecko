class HintValidator < ActiveModel::Validator
  def validate(record)
    hints = record.visit.hints

    unless hints.any?
      return
    end

    unrated_hints = hints.where(opened: true, rating: nil)
    if unrated_hints.exists?
      message = "Nejprve ohodnoťte hvězdičkami všechny přijaté nápovědy"
      record.errors.add(:base, message)
    end

#    has_accepted_hint = hints.where(opened: true, accepted: true).exists?
#    if !has_accepted_hint
#      message = "Alespoň jednu nápovědu musíte označit jako přijatou"
#      record.errors.add(:base, message)
#    end
  end
end

class Answer < ApplicationRecord
  belongs_to :visit, autosave: true
  belongs_to :solution, optional: true
  has_one :team, through: :visit
  has_one :puzzle, through: :visit

  validates :solution, uniqueness: { scope: :visit,
                                     allow_blank: true,
                                     message: 'již odesláno' }
  validates_with HintValidator

  accepts_nested_attributes_for :puzzle

  def correct?
    !solution_id.nil?
  end
end
