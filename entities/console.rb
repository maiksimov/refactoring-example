module Entities
  class Console
    STORAGE_FILE = 'accounts.yml'.freeze

    def initialize
      @context = Context.new(STORAGE_FILE)
      @context.state = States::Initial.new(@context)
    end

    def run
      loop do
        @context.state.action
        @context.state = @context.state.next
      end
    rescue ExitError
      puts 'Goodbye!'
    end
  end
end
