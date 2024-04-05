class SharedClipsController < ApplicationController
  schema(:index) do
    optional(:page).value(:integer)
    optional(:per).value(:integer)
  end
  def index
    shared_clips = SharedClip.
                    includes(:user).
                    order(created_at: :desc).
                    page(safe_params[:page]).
                    per(safe_params[:per])

    render json: shared_clips, root: :data, adapter: :json, meta: pagination_dict(shared_clips), each_serializer: SharedClipSerializer
  end

  schema(:create) do
    required(:clip_url).value(:string)
  end
  def create
    service = ClipSharing::Container['save_clip_from_url'].call(
      user: current_user,
      clip_url: safe_params[:clip_url]
    )

    if service.success?
      render json: service.value!, status: 201, root: :data, adapter: :json, serializer: SharedClipSerializer
    else
      render_error!(service.failure[1], 422)
    end
  end
end
