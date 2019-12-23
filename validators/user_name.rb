module CodebreakerConsole
  module Validators
    class UserName < Validator
      MIN_LENGTH = 3
      MAX_LENGTH = 201

      def validate?
        return true if @value.length.between?(3, 201)

        @errors << I18n.t('errors.wrong_name_length', min: MIN_LENGTH, max: MAX_LENGTH)
        super
      end
    end
  end
end
