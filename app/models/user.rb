class User < ApplicationRecord
  has_many :auths
  belongs_to :primary_auth, class_name: 'Auth'
  def self.login(token, provider = :google)
    auth = Auth.enticate token, provider
    return nil unless auth
    unless auth.user
      auth.user = User.create(primary_auth: auth)
      auth.save!
    end
    return auth.user
  end
end
