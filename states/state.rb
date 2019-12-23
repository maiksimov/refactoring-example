module States
  class State
    def initialize(context)
      @context = context
    end

    def action
      raise NotImplementedError
    end

    def next
      StateFactory.new.state(read_input, @context)
    end

    def read_input
      input = STDIN.gets.chomp
      raise ExitError if input == 'exit'

      input
    end
  end
end
