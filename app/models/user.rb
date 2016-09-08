class User < ApplicationRecord
  has_many :auths
  belongs_to :primary_auth, class_name: 'Auth'
  def self.login(token, provider)
    auth = Auth.enticate token, provider
    return nil unless auth
    if auth.user
      auth.user.earliest_token_time = Time.current
      auth.user.save!
    else
      auth.user = User.create primary_auth: auth, earliest_token_time: Time.current
      auth.save!
    end
    return auth
  end

  def logout
    self.earliest_token_time = Time.current
    self.save!
  end
end
