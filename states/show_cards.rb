module States
  class ShowCards < State
    def action
      puts "There is no active cards!\n" if @context.current_account.card.empty?

      @context.current_account.card.each do |card|
        puts "- #{card.number}, #{card.type}"
      end
    end
  end
end
