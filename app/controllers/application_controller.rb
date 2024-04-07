class ApplicationController < ActionController::API
  before_action :authenticate_user!

  include ErrorHandling
  include ValidationHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found!
  rescue_from ::CustomErrors::InvalidParams, with: :render_invalid_params!

  def pagination_dict(relation)
    {
      page: params[:page] || 0,
      per: params[:per] || 25,
      total_count: relation.total_count
    }
  end

  before_action do
    if safe_params && safe_params.failure?
      raise ::CustomErrors::InvalidParams, safe_params.errors(full: true).messages.join(', ')
    end
  end
end
