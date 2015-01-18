class User < ActiveRecord::Base
  has_many :schedules
  belongs_to :group
  belongs_to :setting
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, presence: true, uniqueness: true
  validates :nature, presence: true
end
