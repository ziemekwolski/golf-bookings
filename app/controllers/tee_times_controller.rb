class TeeTimesController < ApplicationController
  before_action :require_login
  before_action :find_club
  before_action :scope


  def index
    @selected_date = Time.zone.parse(tee_times_index_params[:date].to_s).try(:to_date) || Time.zone.today
    @booked_times = @scope.booked_times_by_time(@selected_date)
  rescue ArgumentError
    redirect_to club_tee_times_url(params[:club_id]), notice: "Invalid date range"
  end

  def create
    @tee_time = @scope.new(tee_times_params)
    if @tee_time.save
      redirect_to club_tee_times_url(club_id: params[:club_id], date: @tee_time.booking_time.to_date),:notice => "Time Booked!"
    else
      redirect_to club_tee_times_url(params[:club_id]), alert: @tee_time.errors.full_messages.join(",")
    end
  end

  def destroy
    @tee_time = @scope.exclude_less_then_hours_before(TeeTime::CANCEL_CUTOFF).find(params[:id])

    if @tee_time.destroy
      redirect_to club_tee_times_url(club_id: params[:club_id], date: @tee_time.booking_time.to_date), notice: "booking cancelled"
    else
      redirect_to club_tee_times_url(params[:club_id]), alert: "could not cancel booking."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to club_tee_times_url(params[:club_id]), alert: "Could not find booking time"
  end

private
  def tee_times_index_params
    return {date: Time.zone.today.to_s(:db)} if params.blank?
    params.permit(:date)
  end

  def tee_times_params
    params.require(:tee_time).permit(:booking_time)
  end

  def find_club
    @club = Club.find(params[:club_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to clubs_url, alert: "Could not find club"
  end

  def scope
    @scope = @current_user.tee_times.where(club_id: @club).in_present
  end

end