class CreateSharedClips < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_clips do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title, null: false
      t.string :author_name
      t.string :author_url
      t.string :type
      t.integer :height
      t.integer :width
      t.string :version
      t.string :provider_name
      t.string :provider_url
      t.integer :thumbnail_height
      t.integer :thumbnail_width
      t.text :html

      t.timestamps
    end
  end
end
