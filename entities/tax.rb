module Entities
  class Tax
    USUAL_TYPE = 'usual'.freeze
    CAPITALIST_TYPE = 'capitalist'.freeze
    VIRTUAL_TYPE = 'virtual'.freeze

    def initialize(type)
      @type = type
    end
  end
end
