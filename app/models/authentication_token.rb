class AuthenticationToken < ActiveRecord::Base
  TOKEN_LENGTH    = 32
  EXPIRATION_TIME = 1.hour

  begin :associations
    belongs_to :user
  end

  begin :validations
    validates :auth_token,
      length:     { is: TOKEN_LENGTH },
      presence:   true,
      uniqueness: true
    validates :expires_at,
      presence: true
    validates :user_id,
      presence: true
  end

  def self.active
    where("expires_at > ?", Time.zone.now)
  end

  def refresh!
    self.expires_at = Time.zone.now + EXPIRATION_TIME
    save
  end

end
