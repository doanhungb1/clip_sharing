class Users::FailureApp < Devise::FailureApp
  def http_auth
    render_error!(I18n.t('devise.failure.invalid'), 401)
  end
end