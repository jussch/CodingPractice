class Goal < ActiveRecord::Base
  validates :title, :content, :access, :user_id, :completion, presence: true
  validates :access, inclusion: { in: ["Public", "Private"]}

  belongs_to :author,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :comments, as: :commentable

  def check_if_public
    self.access == "Public" ? "checked" : ""
  end

  def check_if_private
    self.access == "Private" ? "checked" : ""
  end

  def complete_goal
    self.completion = "Complete"
  end

  def is_complete?
    self.completion == "Complete"
  end
end
