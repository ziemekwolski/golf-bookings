class TeeTimesController < ActionController::Base
  def index
    @selected_date = Time.zone.parse(tee_times_params[:date].to_s).try(:to_date) || Time.zone.today
    @booked_times = TeeTime.booked_times_by_time(@selected_date)
  rescue ArgumentError
    redirect_to root_url, notice: "Invalid date range"
  end

private
  def tee_times_params
    return {date: Time.zone.today.to_s(:db)} if params.blank?
    params.permit(:date)
  end

end