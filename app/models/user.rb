class User < ActiveRecord::Base
  
  # == Constants ============================================================
  
  # == Attributes ===========================================================
  
  # == Extensions ===========================================================
  
  authenticates_with_sorcery!

  # == Relationships ========================================================

  has_many :tee_times
    
  # == Validations ==========================================================
  
  validates :name, presence: true
  validates :email, presence: true , email_format: true, uniqueness: true
  validates :password, presence: true
  validates :password, confirmation: true

  # == Scopes ===============================================================
  
  # == Callbacks ============================================================

  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================

end
