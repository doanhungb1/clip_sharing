class SharedClipSerializer < ActiveModel::Serializer
  attributes :id,
            :user_id,
            :youtube_video_id,
            :shared_clip_url,
            :title,
            :description,
            :author_name,
            :author_url,
            :clip_type,
            :height,
            :width,
            :version,
            :provider_name,
            :provider_url,
            :thumbnail_height,
            :thumbnail_width,
            :html,
            :thumbnail_url,
            :created_at,
            :updated_at,
            :user_email

  def user_email
    object.user.email
  end

end