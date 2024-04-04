module ErrorHandling
  def render_error!(message, status)
    render json: {
      error: {
        message: message,
        code: status
      }
    }, status: status
  end

  def render_record_not_found!
    render_error!(I18n.t('errors.not_found'), 404)
  end

  def render_unauthenticated!
    render_error!(I18n.t('devise.failure.invalid'), 401)
  end

  def render_invalid_params!(exception)
    render_error!(exception.message, 400)
  end
end