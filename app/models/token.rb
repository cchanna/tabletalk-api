class Token
  EXPIRE_TIME = 1.day
  def self.create_from(auth)
    payload = {
      sub: auth.user.id,
      name: auth.name,
      iat: Time.current
    }
    encode payload
  end

  def self.validate(token)
    values = decode token
    return nil if Time.current > values['iat'].to_datetime + EXPIRE_TIME
    user = User.find_by id: values['sub']
    return nil unless user
    return nil if user.earliest_token_time > values['iat'].to_time
    return user
  end

private
  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, Figaro.env.tabletalk_client_secret)[0])
  rescue
    nil
  end

  def self.encode(payload)
    JWT.encode(payload, Figaro.env.tabletalk_client_secret)
  end
end
