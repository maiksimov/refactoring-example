module Contracts
  module Input
    EXIT_COMMAND = 'exit'.freeze

    def read_input
      input = STDIN.gets.chomp
      raise ExitError if input == EXIT_COMMAND

      input
    end

    def read_input_with_title(title)
      puts title

      read_input
    end
  end
end
