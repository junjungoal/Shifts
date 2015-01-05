module DatesHelper
  def putstime(time)
    start_time, end_time = time.split("-")
     "#{start_time}:00~#{end_time}:00"
  end
end
