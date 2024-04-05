class AddMoreColumnToSharedClips < ActiveRecord::Migration[7.1]
  def change
    add_column :shared_clips, :thumbnail_url, :string
    rename_column :shared_clips, :type, :clip_type
  end
end
