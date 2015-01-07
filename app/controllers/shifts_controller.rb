class ShiftsController < ApplicationController
  before_action :user_has_not_group
  def index
    @group = User.find(current_user.id).group
    @today_date = Schedule.today_date
    @today_schedules = User.find(current_user.id).schedules.find_by(date: @today_date, status: 3)
    @start, @finish = @today_schedules.shift_time.split("-") if @today_schedules.present?
    @setting = User.find(current_user.id).group.setting.shifttime[Date.today.wday][:time] if current_user.nature == 1 && User.find(current_user.id).group.setting.present?
    @schedules = Schedule.where(group_id: current_user.group_id, date: @today_date, status: 3)
    @date = Schedule.create_date
    @decide_shift = User.find(current_user.id).schedules.decide
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def search
     @group_name = Group.where('name LIKE(?)', "%#{search_params[:keyword]}%").limit(20)
     @groups = User.find(current_user.id).group
  end

  def new
    @schedules = Schedule.create_next_date
    if Group.find(current_user.group_id).setting.present?
      setting = Group.find(current_user.group_id).setting.shifttime
      @set_time = setting.map{|t| t[:time]}
      @set_time.map{|t| t.delete("")}
      @set_day = setting.map{|t| t[:day]}
    else
      redirect_to "/users/#{current_user.id}/shifts"
    end
    @group = User.find(current_user.id).group
  end

  def create
    #スケジュール提出＝＞作成
    schedules = params[:schedules] #strong parameter使ってみる
    schedules.keys.each do |k|
      if schedules[k]["shift_time"] != "なし"
        Schedule.create(date: k, shift_time: schedules[k]["shift_time"], user_id: current_user.id, group_id: params[:id], status: 1 )
      end
    end
    redirect_to :root
  end

  def next_month
    @date = Schedule.create_next_date
    @decide_shift = User.find(current_user.id).schedules.decide
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  private
  def user_has_not_group
    redirect_to '/groups/new' if current_user.nature == 1 && current_user.group_id.nil?
  end

  def search_params
    params.permit(:keyword)
  end
end
