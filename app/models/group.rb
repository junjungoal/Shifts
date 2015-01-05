class Group < ActiveRecord::Base
  has_many :users
  has_many :schedules
  has_one :setting
end
