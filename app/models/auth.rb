class Auth < ApplicationRecord
  belongs_to :user, optional: true
  enum_accessor :provider, [:google]
  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true

  def self.enticate(token, provider)
    auth = nil
    if provider == :google
      validator = GoogleIDToken::Validator.new
      jwt = validator.check token, Figaro.env.google_client_id, Figaro.env.google_client_id
      puts jwt
      if jwt
        auth = Auth.find_by google_auth_params jwt
        unless auth
          auth = Auth.new google_auth_params jwt
        end
        auth.name = jwt['email']
        auth.save!
      end
    end
    return auth
  end

private
  def self.google_auth_params(jwt)
    return {uid: jwt['sub'], provider: Auth.providers[:google]}
  end
end
