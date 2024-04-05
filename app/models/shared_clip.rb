class SharedClip < ApplicationRecord
  validates :title, :author_name, presence: true
  belongs_to :user
end
