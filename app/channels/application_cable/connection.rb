module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user request.params['token']
    end

    private

    def find_verified_user token
      decoded_token = JWT.decode(token.split(' ')[1], ENV['DEVISE_JWT_SECRET'], true)
      current_user = User.find_by(id: decoded_token.first['sub'])

      if current_user.present?
        return current_user
      else
        return reject_unauthorized_connection
      end
    end
  end
end
