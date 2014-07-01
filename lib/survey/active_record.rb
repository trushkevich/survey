module Survey
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def has_surveys
        has_many :survey_tentatives, as: :participant, :class_name => ::Survey::Attempt

        define_method("for_survey") do |survey|
          self.survey_tentatives.where(:survey_id => survey.id)
        end
      end


      def acceptable_attributes(*args)
        const = 'AccessibleAttributes'
        self.send(:remove_const, const) if self.const_defined?(const)
        self.const_set(const, args + [:id, :_destroy])

        in_rails_3 do
          if defined?(self.respond_to?(:attr_accessible))
            attr_accessible(*self.const_get(const).map { |k| k.is_a?(Hash) ? k.keys.first : k })
          end
        end
      end
    end
  end
end
