module Survey
  class Answer < ::ActiveRecord::Base
    self.table_name = "survey_answers"

    acceptable_attributes :attempt, :option, :correct, :option_id, :question, :question_id, :text

    # associations
    belongs_to :attempt
    belongs_to :option
    belongs_to :question

    # validations
    validates :option_id, :question_id, :presence => true
    validates :option_id, :uniqueness => { :scope => [:attempt_id, :question_id] }

    # callbacks
    after_create :characterize_answer

    def value
      if option_id > 0
        points = (self.option.nil? ? ::Survey::Option.find(option_id) : self.option).weight
        correct?? points : - points
      else
        0
      end
    end

    def correct?
      self.correct ||= self.option.try(:correct?)
    end

    private

    def characterize_answer
      update_attribute(:correct, option.try(:correct?))
    end
  end
end
