class Team < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable,
         :validatable

  has_many :visits, dependent: :destroy
  has_many :answers, through: :visits
  has_many :hint_requests, through: :visits
  has_many :received_hints, through: :hint_requests, source: :hints
  has_many :sent_hints, class_name: 'Hint'
  has_many :team_messages

  validates :name, presence: true, uniqueness: true
  validates_presence_of :player1_name, :player1_email
  validates_confirmation_of :password, message: 'se musí shodovat'
  validates :phone, format: {
    with: /\A[0-9]{9}\z/,
    message: 'je v neplatném formátu'
  }

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def hint_quality
    # Average rating of hints sent by the team that have a rating. If no rated
    # hint exists yet, default to 3 stars.
    '%.1f' % (sent_hints.average(:rating) || 3.0)
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
