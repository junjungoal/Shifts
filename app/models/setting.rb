class Setting < ActiveRecord::Base
  belongs_to :group
  has_many :users
  serialize :shifttime
end
