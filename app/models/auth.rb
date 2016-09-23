class Auth < ApplicationRecord
  belongs_to :user, optional: true
  enum_accessor :provider, [:google, :test]
  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true

  def self.enticate(token, provider)
    auth = nil
    return unless token
    case provider
    when "google"
      validator = GoogleIDToken::Validator.new
      jwt = validator.check token, Figaro.env.google_client_id, Figaro.env.google_client_id
      if jwt
        auth = Auth.find_by google_auth_params jwt
        unless auth
          auth = Auth.new google_auth_params jwt
        end
        auth.name = jwt['email']
        auth.save!
      end
    when "test"
      return nil unless Rails.env.test?
      auth = Auth.find_by test_auth_params token
      unless auth
        auth = Auth.new test_auth_params token
      end
      auth.name = "TEST USER"
      auth.save!
    end
    return auth
  end

private
  def self.google_auth_params(jwt)
    return {uid: jwt['sub'], provider: Auth.providers[:google]}
  end

  def self.test_auth_params(token)
    return {uid: token, provider: Auth.providers[:test]}
  end
end
