class TeeTime < ActiveRecord::Base
  # == Constants ============================================================
  
  BOOKING_INTERVAL = 20

  # == Attributes ===========================================================
  
  # == Extensions ===========================================================
  
  # == Relationships ========================================================
  
  # == Validations ==========================================================

  validate :validates_booking_time_interval
  
  # == Scopes ===============================================================
  
  # == Callbacks ============================================================
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def validates_booking_time_interval
    if booking_time.present? && booking_time.min % BOOKING_INTERVAL != 0 || booking_time.sec != 0
      errors.add(:booking_time, "must in intervals of #{BOOKING_INTERVAL}")
    end
  end

end
