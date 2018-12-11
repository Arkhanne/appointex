class SchedulesController < ApplicationController
  before_action :require_professional

  def create
    @schedule = Schedule.create(schedule_params)
  end

  def update
    schedule_to_delete = Schedule.find_by(id: params[:id])
    @schedule = Schedule.new(owner: schedule_to_delete.owner, week_day: schedule_to_delete.week_day, hour: schedule_to_delete.hour)
    schedule_to_delete.destroy
  end

  def show
    @page = params[:page].blank? ? 1 : params[:page].to_i
  end

  private

  def schedule_params
    params.require(:schedule).permit(:owner_id, :week_day, :hour)
  end
end
