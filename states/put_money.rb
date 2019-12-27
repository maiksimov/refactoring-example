module States
  class PutMoney < State
    def action
      puts 'Choose the card for putting:'

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
              puts 'Input the amount of money you want to put on your card'
              a2 = read_input
              if a2.to_i > 0
                if put_tax(current_card.type, a2.to_i) >= a2.to_i
                  puts 'Your tax is higher than input amount'
                  return
                else
                  new_money_amount = current_card.balance + a2.to_i - put_tax(current_card.type, a2.to_i)
                  current_card.balance = new_money_amount
                  @context.current_account.card[answer.to_i - 1] = current_card

                  # new_accounts = []
                  # @accounts.each do |account|
                  #   if account.login == @current_account.login
                  #     new_accounts.push(@current_account)
                  #   else
                  #     new_accounts.push(account)
                  #   end
                  # end
                  # @accounts = new_accounts

                  @context.save
                  puts "Money #{a2.to_i} was put on #{current_card.number}. Balance: #{current_card.balance}. Tax: #{put_tax(current_card.type, a2.to_i)}"
                  return
                end
              else
                puts 'You must input correct amount of money'
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
