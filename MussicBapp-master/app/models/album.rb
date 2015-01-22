class Album < ActiveRecord::Base
  validates :name, :band_id, :album_type, presence: true

  has_many :tracks, dependent: :destroy

  belongs_to :band

  def select_if_live
    "checked" if self.album_type == "Live Album"
  end

  def select_if_studio
    "checked" if self.album_type == "Studio Album"
  end
end
