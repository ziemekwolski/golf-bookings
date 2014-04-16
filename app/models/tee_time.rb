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

  belongs_to :user
  belongs_to :club

  # == Validations ==========================================================

  validates :booking_time, presence: true, uniqueness: {scope: :club_id}
  validates :user, :club, presence: true
  validate :validates_booking_time_interval
  validate :validates_open_hours
  validate :validates_total_number_of_bookings, on: :create

  
  # == Scopes ===============================================================
  
  scope :within_date, ->(datetime) { 
    start_time = datetime.beginning_of_day
    end_time = datetime.end_of_day
    where("booking_time >= ? and booking_time <= ? ", start_time, end_time) 
  }

  scope :by_booking_times, ->(datetime) { where(booking_time: datetime)}
  scope :in_present, -> {where("booking_time >= ?", Time.zone.today.beginning_of_day)}

  # == Callbacks ============================================================
  
  # == Class Methods ========================================================

  def self.booked_times_by_time(date)
    raise ArgumentError if date.blank?
    parsed_date = Time.zone.parse(date.to_s).to_date

    self.within_date(date).inject({}) {|result, data| result[data.booking_time.strftime("%I:%M %p")] = data; result}
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

  def validates_total_number_of_bookings
    if self.user.present? && self.user.tee_times.in_present.count >= 2
      errors.add(:booking_time, "Users can only have two bookings")
    end
  end


end
