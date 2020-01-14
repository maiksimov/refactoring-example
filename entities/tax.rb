module Entities
  class Tax
    USUAL_TYPE = 'usual'.freeze
    CAPITALIST_TYPE = 'capitalist'.freeze
    VIRTUAL_TYPE = 'virtual'.freeze

    def initialize(type)
      @type = type
    end

    def tax(_amount)
      raise NotImplementedError 'Method tax not implemented'
    end

    def default_tax
      0
    end
  end
end
