class Question < ActiveRecord::Base
  validates :poll_id, :body, presence: true

  belongs_to :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id

  has_many :responses, through: :answer_choices, source: :responses

  def bad_results
    choices = self.answer_choices.includes(:responses)
    results = Hash.new(0)
    choices.each do |choice|
      results[choice.text] = choice.responses.count
    end
    results
  end

  def results
    answers_with_count = self
      .answer_choices
      .select("answer_choices.*, COUNT(responses.id) AS responses_count")
      .joins("LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
      .group("answer_choices.id")
    answers_with_count.map do |answer|
      [answer.text, answer.responses_count]
    end.to_h
  end
end
#
# SELECT
#   answer_choices.*, COUNT(responses.id)
# JOIN
#   responses ON answer_choices.id = responses.answer_choice_id
# JOIN
#   questions ON answer_choices.question_id = questions.id
# WHERE
#   question.id = ? (self.id)
# GROUP BY
#   answer_choices.id
