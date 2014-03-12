class AuthenticationToken < ActiveRecord::Base
  TOKEN_LENGTH    = 20
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

  def self.find_or_create_for(user)
    token = active.find_by_user_id(user.id)

    return token unless token.nil?

    data = {
      user_id:    user.id,
      auth_token: generate_token,
      expires_at: Time.zone.now + 1.hour
    }

    token = create(data)
    token
  end

  def refresh!
    self.expires_at = Time.zone.now + EXPIRATION_TIME
    save
  end

  private
  def self.generate_token
    key_gen = Devise::KeyGenerator.new("123")

    tokenizer = Devise::TokenGenerator.
      new(key_gen).
      generate(AuthenticationToken, :auth_token)

    tokenizer.first
  end
end
