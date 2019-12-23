module CodebreakerConsole
  module Validators
    class Number < Validator
      def validate?
        check_empty
        check_length
        check_range
        super
      end

      private

      def check_empty
        @errors << I18n.t('errors.wrong_number') if @value.to_i.zero?
      end

      def check_length
        return if @value.length == CodebreakerGame::Game::SECRET_LENGTH

        @errors << I18n.t('errors.wrong_number_length',
                          length: CodebreakerGame::Game::SECRET_LENGTH)
      end

      def digit_in_range(digit)
        digit.to_i.between?(CodebreakerGame::Random::DEFAULT_MIN,
                            CodebreakerGame::Random::DEFAULT_MAX)
      end

      def check_range
        return if @value.chars.map(&method(:digit_in_range)).all?

        @errors << I18n.t('errors.wrong_number_digits',
                          min: CodebreakerGame::Random::DEFAULT_MIN,
                          max: CodebreakerGame::Random::DEFAULT_MAX)
      end
    end
  end
end
