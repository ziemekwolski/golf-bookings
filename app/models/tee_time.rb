class TeeTime < ActiveRecord::Base
  # == Constants ============================================================
  
  BOOKING_INTERVAL = 20

  # == Attributes ===========================================================
  
  # == Extensions ===========================================================
  
  # == Relationships ========================================================
  
  # == Validations ==========================================================

  validates :booking_time, presence: true, uniqueness: true
  validate :validates_booking_time_interval
  validate :validates_open_hours
  
  # == Scopes ===============================================================
  
  # == Callbacks ============================================================
  
  # == Class Methods ========================================================
  
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
