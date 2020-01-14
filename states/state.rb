module States
  class State
    include Contracts::Input
    include Contracts::Validators
    include Contracts::Statistics

    AGREE_COMMAND = 'y'.freeze

    def initialize(context)
      @context = context
    end

    def action
      raise NotImplementedError
    end

    def next
      StateFactory.new.state(read_input, @context)
    end

    def save_context
      @context.save
    end
  end
end
