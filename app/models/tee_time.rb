class TeeTime < ActiveRecord::Base
  # == Constants ============================================================
  
  BOOKING_INTERVAL = 20
  OPEN_TIME = "9 AM"
  CLOSE_TIME = "5 PM"

  ALL_AVAILABLE_TIMES = ["09:00 AM", "09:20 AM", "09:40 AM", "10:00 AM", "10:20 AM", 
    "10:40 AM", "11:00 AM", "11:20 AM", "11:40 AM", "12:00 PM", "12:20 PM", "12:40 PM",
     "01:00 PM", "01:20 PM", "01:40 PM", "02:00 PM", "02:20 PM", "02:40 PM", "03:00 PM", 
     "03:20 PM", "03:40 PM", "04:00 PM", "04:20 PM", "04:40 PM"].freeze

  # == Attributes ===========================================================
  
  # == Extensions ===========================================================
  
  # == Relationships ========================================================
  
  # == Validations ==========================================================

  validates :booking_time, presence: true, uniqueness: true
  validate :validates_booking_time_interval
  validate :validates_open_hours
  
  # == Scopes ===============================================================
  
  scope :within_date, ->(datetime) { 
    parsed_datetime = Time.zone.parse(datetime) rescue Time.zone.today

    start_time = parsed_datetime.beginning_of_day
    end_time = parsed_datetime.end_of_day
    where("booking_time >= ? and booking_time <= ? ", start_time, end_time) 
  }

  # == Callbacks ============================================================
  
  # == Class Methods ========================================================

  def self.list_available_times_for(date)
    parsed_date = Time.zone.parse(date.to_s) rescue nil
    return [] if parsed_date.blank?

    booked_times = self.within_date(date).pluck(:booking_time).collect {|t| t.strftime("%I:%M %p") }
    ALL_AVAILABLE_TIMES - booked_times
  end
  
  # == Instance Methods =====================================================

  def validates_booking_time_interval
    if booking_time.present? && (booking_time.min % BOOKING_INTERVAL != 0 || booking_time.sec != 0)
      errors.add(:booking_time, "must in intervals of #{BOOKING_INTERVAL}")
    end
  end

  def validates_open_hours
    if booking_time.present? && (booking_time.hour < 9 || booking_time.hour >= 17)
      errors.add(:booking_time, "must be between 9am and 5pm")
    end
  end


end
