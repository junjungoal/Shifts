class Schedule < ActiveRecord::Base

  # assosiation
  belongs_to :user

  # status
  enum status: {submit: 1, deny: 2, decide: 3}

  #scope
  # scope :get_shifts, ->(date, start_time, end_time, current_user.team_id) { where(date: date, start_time: start_time, end_time: end_time, team_id: current_user.team_id)}
  # constants
  MAX_PEOPLE = 2
  TODAY = Date.today

  class << self
    def create_date
      month = TODAY.month
      year = TODAY.year
      days = Time.days_in_month( month, year )
      (Date.parse("#{year}-#{month}-1")..Date.parse("#{year}-#{month}-#{days}"))
    end

    def create_next_date
      next_date = TODAY.next_month
      next_year = next_date.year
      next_month = next_date.month
      next_days = Time.days_in_month( next_month, next_year )
      (Date.parse("#{next_year}-#{next_month}-1")..Date.parse("#{next_year}-#{next_month}-#{next_days}"))
    end

    def today_date
      month = Date.today.month
      day = Date.today.day
      year = Date.today.year
      "#{year}-#{month}-#{day}"
    end
    def decide_date(group_id, setting_time, max_people)
      next_date = TODAY.next_month
      next_year = next_date.year
      next_month = next_date.month
      next_days = Time.days_in_month( next_month, next_year )
      (Date.parse("#{next_year}-#{next_month}-1")..Date.parse("#{next_year}-#{next_month}-#{next_days}")).each do |date|
        setting_time.each do |i|
          i.each do |t|
            each_date_shift = where(date: date, shift_time: t, group_id: group_id )
            if each_date_shift.present?
              decide_shifts = []
              while under_max_people?(decide_shifts.count, each_date_shift.count, max_people[date.wday]) do
                decide_shifts << each_date_shift.sample
                decide_shifts.uniq!
              end
              decide_shifts.each{|i| i.decide!}
              rest_decide_shifts = each_date_shift - decide_shifts
              rest_decide_shifts.each{|i| i.deny!}
            end
          end
        end
      end
    end

    def under_max_people?(decide_shifts_count, date_shift_count, max_people)
      decide_shifts_count < max_people.first.to_i && decide_shifts_count < date_shift_count
    end
  end
end
