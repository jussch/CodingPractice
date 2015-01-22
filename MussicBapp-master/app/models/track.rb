class Track < ActiveRecord::Base
  validates :name, :track_type, :album_id, :lyrics, presence: true

  belongs_to :album

  has_one :band, through: :album, source: :band

  has_many :notes, dependent: :destroy

  def select_if_regular
    "checked" if self.track_type == "Regular"
  end
  def select_if_bonus
    "checked" if self.track_type == "Bonus"
  end
end
