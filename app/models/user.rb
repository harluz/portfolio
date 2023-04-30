class User < ApplicationRecord
  has_many :quests
  has_many :challenges
  has_many :messages

  VALID_EMAIL_ERGEX = /\A\S+@\S+\.\S+\z/
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_ERGEX }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :having_xp, presence: true, numericality: { only_integer: true }
  validates :level, presence: true, numericality: { only_integer: true }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
