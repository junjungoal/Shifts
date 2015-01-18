class HostsController < ApplicationController
  before_action :user_has_not_group, :user_status_wrong
  def new
     @group = Group.find(params[:id])
     @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def decide
    if Group.find(params[:id]).setting.present?
      pre_setting_time = Group.find(params[:id]).setting.shifttime
      pre_setting_time.map!{|t| t[:time]}
      pre_setting_time.map!{|t| t - ["","なし"] }
      set_time =pre_setting_time
      max_people =  Group.find(params[:id]).setting.shifttime.map!{|t| t[:people]}
      Schedule.decide_date(params[:id], set_time, max_people)
      redirect_to "/users/#{current_user.id}/shifts"
    else
      redirect_to "/users/#{current_user.id}/shifts"
    end
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def acount_setting
  end

  def acount_setting_decide
    setting = Setting.find_by(group_id: params[:id])
    setting.destroy if setting.present?
    Setting.create(shifttime: params[:posts], group_id: params[:id])
    redirect_to :root
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def approval
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def user_add
    user = User.find(params[:id])
    user.update_attributes(status: 2)
    redirect_to :root
  end

  private
  def user_has_not_group
     redirect_to '/groups/new' if current_user.nature == 1 && current_user.group_id.nil?
  end

  def user_status_wrong
    redirect_to :root if current_user.nature == 2
  end
end
