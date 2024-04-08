class SaveClipFromUrl
  include Dry::Monads[:result, :do]

  YOUTUBE_INFO_LINK = 'https://www.googleapis.com/youtube/v3/videos'.freeze
  YOUTUBE_REGEX = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
  YOUTUBE_API_KEY = ENV['YOUTUBE_API_KEY']

  def call(user: , clip_url:)
    yield validate!(clip_url)
    video_id = get_youtube_video_id(clip_url)
    clip_info = yield get_clip_info(video_id)
    saved_shared_clip = yield process_saved_clip(user, clip_info, clip_url)
    broadcast_notification(saved_shared_clip)

    Success(saved_shared_clip)
  end

  private

  def validate!(clip_url)
    unless clip_url.match?(YOUTUBE_REGEX)
      return Failure([:invalid_params, I18n.t('errors.invalid_parameter', param: :url)])
    end

    Success()
  end

  def get_clip_info(video_id)
    res = RestClient.get(
      YOUTUBE_INFO_LINK + "?id=#{video_id}&key=#{YOUTUBE_API_KEY}&fields=items(id,snippet(title),snippet(description))&part=snippet"
    )

    data = JSON.parse(res.body)['items'].first
    return Failure([:invalid_params, I18n.t('errors.invalid_parameter', param: :url)]) unless data
    Success(data)
  rescue RestClient::BadRequest, RestClient::NotFound => _error
    Failure([:invalid_params, I18n.t('errors.invalid_parameter', param: :url)])
  end

  def process_saved_clip(user, clip_info, clip_url)
    saved_clip = user.shared_clips.new(
      title: clip_info['snippet']['title'],
      description: clip_info['snippet']['description'],
      shared_clip_url: clip_url,
      youtube_video_id: clip_info['id']
    )


    if saved_clip.save
      Success(saved_clip)
    else
      Failure([:failed_to_saved_clip, saved_clip.errors.full_messages.first])
    end
  end

  def broadcast_notification(saved_shared_clip)
    ActionCable.server.broadcast(
      'notifications',
      {
        author: saved_shared_clip.user.email,
        title: saved_shared_clip.title,
        description: saved_shared_clip.description
      }
    )
  end

  def get_youtube_video_id(clip_url)
    Rack::Utils.parse_query(URI(clip_url).query)['v']
  end
end