class Comment < ActiveRecord::Base
  validates :body, :user_id, :commentable, presence: true

  belongs_to :user

  belongs_to :commentable, polymorphic: true

end
