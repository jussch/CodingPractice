class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question

  belongs_to :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  belongs_to :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id

  has_one :question, through: :answer_choice, source: :question

  def sibling_responses
    # self.question.responses.where("responses.id != ?", self.id)
    Response.joins(:answer_choice).distinct
      .joins("JOIN questions ON answer_choices.question_id = questions.id")
      .joins("JOIN answer_choices AS all_answers ON questions.id = all_answers.question_id")
      .where("answer_choices.id = #{self.answer_choice_id} AND responses.id != #{self.id}")
  end

  private
  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: self.user_id)
      errors[:user_id] << "this user already responded to this question"
    end
  end

  def author_cannot_respond_to_own_poll
    query = Poll.joins(:questions)
      .joins("JOIN answer_choices ON questions.id = answer_choices.question_id")
      .where("answer_choices.id = #{self.answer_choice_id}")
      .select("polls.author_id")
    if query.first.author_id == self.user_id
      errors[:user_id] << "A poll's author cannot respond to their own poll"
    end
  end
end
