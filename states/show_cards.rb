module States
  class ShowCards < State
    def action
      if @context.current_account.card.empty?
        puts "There is no active cards!\n"
      end

      @context.current_account.card.each do |card|
        puts "- #{card.number}, #{card.type}"
      end
    end
  end
end
