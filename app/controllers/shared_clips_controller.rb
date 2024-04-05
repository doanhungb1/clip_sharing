class SharedClipsController < ApplicationController
  schema(:create) do
    required(:clip_url).value(:string)
  end
  def create
    service = ClipSharing::Container['save_clip_from_url'].call(
      user: current_user,
      clip_url: safe_params[:clip_url]
    )

    if service.success?
      render json: service.value!, status: 201
    else
      render_error!(service.failure[1], 422)
    end
  end
end
