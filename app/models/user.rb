class User < ApplicationRecord
  has_many :auths
  has_many :players
  has_many :games, through: :players
  belongs_to :primary_auth, class_name: 'Auth'
  def self.login(token, provider)
    auth = Auth.enticate token, provider
    return nil unless auth
    if auth.user
      Rails::logger.debug 'RETURNING USER'
      auth.user.save!
    else
      Rails::logger.debug 'NEW USER'
      auth.user = User.create primary_auth: auth, earliest_token_time: Time.current
      auth.save!
    end
    return auth
  end

  def logout
    self.earliest_token_time = Time.current
    self.save!
  end

  def self.authorize(token)
    Token.validate token
  end
end
