class DatesController < ApplicationController

  def show
    @schedules = Schedule.where(group_id: current_user.group_id, date: params[:date], status: 3)
    date = Date.parse(params[:date]).wday
    @setting = User.find(current_user.id).group.setting.shifttime[date][:time]
    @setting.delete("なし")
    @setting.delete("")
    @user = User.where(group_id: current_user.group_id, status: 1)
  end


  def destroy
    Schedule.find(params[:id]).deny!
    redirect_to "/dates/#{params[:date]}"
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def add_shift
    @shift_people = Schedule.where(date: params[:date], status: 2, group_id: current_user.group_id, shift_time: params[:time])
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def add
    Schedule.find(params[:id]).decide!
    @user = User.where(group_id: current_user.group_id, status: 1)
    redirect_to "/dates/#{params[:date]}"
  end
end
