class Vote < ActiveRecord::Base
  validates :value, :voter_id, :voteable_id, :voteable_type, presence: true
  validates :value, inclusion: {in: [-1, 1]}

  belongs_to :voteable, polymorphic: true

end
