class User < ApplicationRecord
  has_many :quests
  has_many :challenges, dependent: :destroy
  has_many :messages, dependent: :destroy

  VALID_EMAIL_ERGEX = /\A\S+@\S+\.\S+\z/
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_ERGEX }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :having_xp, presence: true, numericality: { only_integer: true }
  validates :challenge_achieved, presence: true, numericality: { only_integer: true }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.name = 'ゲストユーザー'
    end
  end

  def experience_needed_for_next_grade
    current_grade = GradeSetting.find_by(grade: self.grade)
    if current_grade.grade == "Legend"
      0
    else
      current_grade.judgement_xp - self.having_xp
    end
  end
end
