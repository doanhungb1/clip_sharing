class AddMoreColumnToSharedClip < ActiveRecord::Migration[7.1]
  def change
    add_column :shared_clips, :shared_clip_url, :string
    add_column :shared_clips, :youtube_video_id, :string
    add_column :shared_clips, :description, :text
  end
end
