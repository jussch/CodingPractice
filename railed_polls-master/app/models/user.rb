class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many :polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id

  has_many :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id

  def completed_polls

    subquery = Question.select("questions.*")
      .joins("JOIN answer_choices ON answer_choices.question_id = questions.id")
       .joins("JOIN responses ON responses.answer_choice_id = answer_choices.id")
       .where("responses.user_id = #{self.id}")

    Poll.select("polls.*, COUNT(questions.*) AS questions_count")
      .joins(:questions)
      .joins("LEFT OUTER JOIN (#{subquery.to_sql }) AS q ON q.id = questions.id")
      .having("COUNT(q.*) = COUNT(questions.*)")
      .group("polls.id")
  end

  def uncompleted_polls
    subquery = Question.select("questions.*")
      .joins("JOIN answer_choices ON answer_choices.question_id = questions.id")
      .joins("JOIN responses ON responses.answer_choice_id = answer_choices.id")
      .where("responses.user_id = #{self.id}")

    Poll.select("polls.*, COUNT(questions.*) AS questions_count")
      .joins(:questions)
      .joins("LEFT OUTER JOIN (#{subquery.to_sql }) AS q ON q.id = questions.id")
      .having("COUNT(q.*) != COUNT(questions.*) AND COUNT(q.*) > 0")
      .group("polls.id")
  end

end
