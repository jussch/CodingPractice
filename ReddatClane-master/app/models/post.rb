class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true

  has_many :post_subs

  has_many :subs, through: :post_subs, source: :sub

  has_many :comments

  has_many :votes, as: :voteable

  belongs_to :author,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  def comments_by_parent_id
    comments_by_parent_id = Hash.new {Array.new}
    self.comments.includes(:author).each do |comment|
      comments_by_parent_id[comment.parent_comment_id] += [comment]
    end
    comments_by_parent_id
  end

  def vote_count
    result = 0
    self.votes.each do |vote|
      result += vote.value
    end
    result
  end

end
