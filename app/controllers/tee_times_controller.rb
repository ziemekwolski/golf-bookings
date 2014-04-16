class TeeTimesController < ApplicationController
  before_action :require_login
  before_action :find_tee_time, only: [:destroy]

  def index
    @selected_date = Time.zone.parse(tee_times_index_params[:date].to_s).try(:to_date) || Time.zone.today
    @booked_times = TeeTime.booked_times_by_time(@selected_date)
  rescue ArgumentError
    redirect_to tee_times_url, notice: "Invalid date range"
  end

  def create
    @tee_time = TeeTime.new(tee_times_params)
    if @tee_time.save
      redirect_to tee_times_url(date: @tee_time.booking_time.to_date),:notice => "Time Booked!"
    else
      redirect_to tee_times_url,:error => "Invalid Time"
    end
  end

  def destroy
    if @tee_time.destroy
      redirect_to tee_times_url(date: @tee_time.booking_time.to_date), notice: "booking cancelled"
    else
      redirect_to tee_times_url, error: "could not cancel booking."
    end
  end

private
  def tee_times_index_params
    return {date: Time.zone.today.to_s(:db)} if params.blank?
    params.permit(:date)
  end

  def tee_times_params
    params.require(:tee_time).permit(:booking_time)
  end

  def find_tee_time
    @tee_time = TeeTime.in_present.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tee_times_url, error: "Could not find booking time" 
  end

end