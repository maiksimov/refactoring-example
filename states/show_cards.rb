module States
  class ShowCards < State
    def action
      if @context.current_account.card.any?
        @context.current_account.card.each do |card|
          puts "- #{card.number}, #{card.type}"
        end
      else
        puts "There is no active cards!\n"
      end
    end
  end
end
