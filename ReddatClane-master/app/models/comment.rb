class Comment < ActiveRecord::Base
  validates :content, :author_id, :post_id, presence: true

  belongs_to :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id

  belongs_to :post

  belongs_to :parent,
    class_name: "Comment",
    foreign_key: :parent_comment_id,
    primary_key: :id

  has_many :child_comments, inverse_of: :parent

  has_many :votes, as: :voteable

  def vote_count
    result = 0
    self.votes.each do |vote|
      result += vote.value
    end
    result
  end
  
end
