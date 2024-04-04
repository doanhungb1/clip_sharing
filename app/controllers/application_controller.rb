class ApplicationController < ActionController::API
  before_action :authenticate_devise_user!

  include ErrorHandling
  include ValidationHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found!
  rescue_from ::CustomErrors::InvalidParams, with: :render_invalid_params!

  def authenticate_devise_user!
    authenticate_user!

    render_unauthenticated! if current_user.nil?
  end

  before_action do
    if safe_params && safe_params.failure?
      raise ::CustomErrors::InvalidParams, safe_params.errors(full: true).messages.join(', ')
    end
  end
end
