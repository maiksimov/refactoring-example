module CodebreakerConsole
  module Validators
    class Difficulty < Validator
      ALLOW_NAMES = %w[easy medium hard].freeze

      def validate?
        return true if ALLOW_NAMES.include?(@value)

        @errors << I18n.t('errors.wrong_difficulty')
        super
      end
    end
  end
end
