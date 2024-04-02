class ApplicationController < ActionController::API
  before_action :authenticate_devise_user!

  def authenticate_devise_user!
    authenticate_user!

    if current_user.nil?
      render json: {
        messages: [I18n.t('devise.failure.invalid')],
      }, status: 401
    end
  end
end
