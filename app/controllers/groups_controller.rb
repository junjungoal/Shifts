class GroupsController < ApplicationController

  def new
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

  def create
    if User.find(current_user.id).nature == 1
      Group.create(name: create_params[:name], contents: create_params[:contents] )
      group_id = Group.find_by(name: params[:name]).id
      User.find(current_user.id).update_attributes(group_id: group_id)
      redirect_to "/users/#{current_user.id}/shifts"
    elsif User.find(current_user.id).nature == 2
      User.find(current_user.id).update_attributes(group_id: params[:group], status: 1)
      redirect_to "/users/#{current_user.id}/shifts"
    end
    @user = User.where(group_id: current_user.group_id, status: 1)
  end

   private
  def create_params
    params.permit(:name, :contents)
  end
end
