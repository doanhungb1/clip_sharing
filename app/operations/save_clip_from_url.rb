class SaveClipFromUrl
  include Dry::Monads[:result, :do]

  YOUTUBE_INFO_LINK = 'https://www.youtube.com/oembed?format=json&url='.freeze

  def call(user: , clip_url:)
    clip_info = yield get_clip_info(clip_url)
    saved_shared_clip = yield process_saved_clip(user, clip_info)

    Success(saved_shared_clip)
  end

  private

  def get_clip_info(clip_url)
    res = RestClient.get(YOUTUBE_INFO_LINK + clip_url)
    Success(JSON.parse(res.body))
  rescue RestClient::BadRequest, RestClient::NotFound => _error
    Failure([:invalid_params, I18n.t('errors.invalid_parameter', param: :url)])
  end

  def process_saved_clip(user, clip_info)
    saved_clip = user.shared_clips.new(
      title: clip_info['title'],
      author_name: clip_info['author_name'],
      author_url: clip_info['author_url'],
      clip_type: clip_info['type'],
      height: clip_info['height'],
      width: clip_info['width'],
      version: clip_info['version'],
      provider_name: clip_info['provider_name'],
      provider_url: clip_info['provider_url'],
      thumbnail_height: clip_info['thumbnail_height'],
      thumbnail_width: clip_info['thumbnail_width'],
      thumbnail_url: clip_info['thumbnail_url'],
      html: clip_info['html']
    )

    if saved_clip.save
      Success(saved_clip)
    else
      Failure([:failed_to_saved_clip, saved_clip.errors.full_messages.first])
    end
  end
end