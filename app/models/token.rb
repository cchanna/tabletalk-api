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
    return nil if token.nil?
    values = decode token
    return nil unless values
    Rails::logger.debug values
    return nil if Time.current > values['iat'].to_datetime + EXPIRE_TIME
    user = User.find_by id: values['sub']
    Rails::logger.debug user.id
    return nil unless user
    Rails::logger.debug 'ETT ' + user.earliest_token_time.to_time.to_s
    Rails::logger.debug 'IAT ' + (values['iat'].to_time + 1.second).to_s
    Rails::logger.debug user.earliest_token_time > values['iat'].to_time + 1.second
    return nil if user.earliest_token_time > values['iat'].to_time + 1.second
    Rails::logger.debug user.id
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
