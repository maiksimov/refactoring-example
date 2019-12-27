module States
  class WithdrawMoney < State
    def action
      puts 'Choose the card for withdrawing:'
      answer, a2, a3 = nil #answers for read_input
      if @context.current_account.card.any?
        @context.current_account.card.each_with_index do |card, i|
          puts "- #{card.number}, #{card.type}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        loop do
          answer = read_input

          if answer.to_i <= @context.current_account.card.length && answer.to_i > 0
            current_card = @context.current_account.card[answer.to_i - 1]
            loop do
              puts 'Input the amount of money you want to withdraw'
              a2 = read_input
              if a2.to_i > 0
                money_left = current_card.balance - a2.to_i - withdraw_tax(current_card.type, a2.to_i)
                if money_left > 0
                  current_card.balance = money_left
                  @context.current_account.card[answer.to_i - 1] = current_card
                  # new_accounts = []
                  # @accounts.each do |ac|
                  #   if ac.login == @current_account.login
                  #     new_accounts.push(@current_account)
                  #   else
                  #     new_accounts.push(ac)
                  #   end
                  # end
                  # @accounts = new_accounts
                  @context.save
                  puts "Money #{a2.to_i} withdrawed from #{current_card.number}$. Money left: #{current_card.balance}$. Tax: #{withdraw_tax(current_card.type, a2.to_i)}$"
                  return
                else
                  puts "You don't have enough money on card for such operation"
                  return
                end
              else
                puts 'You must input correct amount of $'
                return
              end
            end
          else
            puts "You entered wrong number!\n"
            return
          end
        end
      else
        puts "There is no active cards!\n"
      end
    end

    def next
      AccountMenu.new(@context)
    end

    def withdraw_tax(type, amount)
      Entities::WithdrawTax.new(type).tax(amount)
    end

    def put_tax(type, amount)
      Entities::PutTax.new(type).tax(amount)
    end

    def sender_tax(type, amount)
      Entities::SenderTax.new(type).tax(amount)
    end
  end
end
