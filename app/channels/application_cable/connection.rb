module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      user = User.authorize request.params[:token]
      return reject_unauthorized_connection unless user
      self.current_user = user
    end
  end
end
