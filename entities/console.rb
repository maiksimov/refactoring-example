module Entities
  class Console
    attr_accessor :login, :card, :file_path
    STORAGE_FILE = 'accounts.yml'.freeze
    
    def initialize
      @file_path = STORAGE_FILE
    end

    def run
      puts 'Hello, we are RubyG bank!'
      puts '- If you want to create account - press `create`'
      puts '- If you want to load account - press `load`'
      puts '- If you want to exit - press `exit`'

      case read_input
      when 'create' then create
      when 'load' then load
      else
        exit
      end
    end

    def create
      loop do
        @current_account = Entities::Account.new(name: name_input, age: age_input, login: login_input, password: password_input, accounts: accounts)
        break if @current_account.validated?

        @current_account.errors.each do |error|
          puts error
        end
      end
      new_accounts = accounts << @current_account
      save(new_accounts)
      main_menu
    end

    def load
      loop do
        if accounts.empty?
          return create_the_first_account
        end

        puts 'Enter your login'
        login = read_input
        puts 'Enter your password'
        password = read_input

        if accounts.map { |account| { login: account.login, password: account.password } }.include?({ login: login, password: password })
          @current_account = accounts.select { |account| login == account.login }.first
          break
        else
          puts 'There is no account with given credentials'
          next
        end
      end
      main_menu
    end

    def create_the_first_account
      puts 'There is no active accounts, do you want to be the first?[y/n]'
      return create if read_input == 'y'

      run
    end

    def main_menu
      loop do
        puts "\nWelcome, #{@current_account.name}"
        puts 'If you want to:'
        puts '- show all cards - press SC'
        puts '- create card - press CC'
        puts '- destroy card - press DC'
        puts '- put money on card - press PM'
        puts '- withdraw money on card - press WM'
        puts '- send money to another card  - press SM'
        puts '- destroy account - press `DA`'
        puts '- exit from account - press `exit`'
        case read_input
        when 'SC' then show_cards
        when 'CC' then create_card
        when 'DC' then destroy_card
        when 'PM' then put_money
        when 'WM' then withdraw_money
        when 'SM' then send_money
        when 'DA'
          destroy_account
          exit
        when 'exit'
          exit
          break
        else
          puts "Wrong command. Try again!\n"
        end
      end
    end

    def create_card
      loop do
        puts 'You could create one of 3 card types'
        puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
        puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
        puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
        puts '- For exit - press `exit`'
        card = case read_input
               when 'usual'
                 Card.new(
                     type: 'usual',
                     number: 16.times.map{rand(10)}.join,
                     balance: 50.00
                 )
               when 'capitalist'
                 Card.new(
                     type: 'capitalist',
                     number: 16.times.map{rand(10)}.join,
                     balance: 100.00
                 )
               when 'virtual'
                 Card.new(
                     type: 'virtual',
                     number: 16.times.map{rand(10)}.join,
                     balance: 150.00
                 )
               else
                 puts "Wrong card type. Try again!\n"
                 next
               end

        @current_account.card <<= card
        new_accounts = []
        accounts.each do |account|
          if account.login == @current_account.login
            new_accounts.push(@current_account)
          else
            new_accounts.push(account)
          end
        end
        save(new_accounts)
        break
      end
    end

    def destroy_card
      loop do
        if @current_account.card.any?
          puts 'If you want to delete:'

          @current_account.card.each_with_index do |c, i|
            puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
          end
          puts "press `exit` to exit\n"
          answer = read_input
          break if answer == 'exit'
          if answer.to_i <= @current_account.card.length && answer.to_i > 0
            puts "Are you sure you want to delete #{@current_account.card[answer.to_i - 1][:number]}?[y/n]"
            a2 = read_input
            if a2 == 'y'
              @current_account.card.delete_at(answer.to_i - 1)
              new_accounts = []
              accounts.each do |account|
                if account.login == @current_account.login
                  new_accounts.push(@current_account)
                else
                  new_accounts.push(account)
                end
              end
              save(new_accounts) #Storing
              break
            else
              return
            end
          else
            puts "You entered wrong number!\n"
          end
        else
          puts "There is no active cards!\n"
          break
        end
      end
    end

    def show_cards
      if @current_account.card.any?
        @current_account.card.each do |c|
          puts "- #{c[:number]}, #{c[:type]}"
        end
      else
        puts "There is no active cards!\n"
      end
    end

    def withdraw_money
      puts 'Choose the card for withdrawing:'
      answer, a2, a3 = nil #answers for read_input
      if @current_account.card.any?
        @current_account.card.each_with_index do |c, i|
          puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        loop do
          answer = read_input
          break if answer == 'exit'
          if answer.to_i <= @current_account.card.length && answer.to_i > 0
            current_card = @current_account.card[answer.to_i - 1]
            loop do
              puts 'Input the amount of money you want to withdraw'
              a2 = read_input
              if a2.to_i > 0
                money_left = current_card[:balance] - a2.to_i - withdraw_tax(current_card[:type], current_card[:balance], current_card[:number], a2.to_i)
                if money_left > 0
                  current_card[:balance] = money_left
                  @current_account.card[answer.to_i - 1] = current_card
                  new_accounts = []
                  accounts.each do |ac|
                    if ac.login == @current_account.login
                      new_accounts.push(@current_account)
                    else
                      new_accounts.push(ac)
                    end
                  end
                  save(new_accounts) #Storing
                  puts "Money #{a2.to_i} withdrawed from #{current_card[:number]}$. Money left: #{current_card[:balance]}$. Tax: #{withdraw_tax(current_card[:type], current_card[:balance], current_card[:number], a2.to_i)}$"
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

    def put_money
      puts 'Choose the card for putting:'

      if @current_account.card.any?
        @current_account.card.each_with_index do |c, i|
          puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        loop do
          answer = read_input
          break if answer == 'exit'
          if answer.to_i <= @current_account.card.length && answer.to_i > 0
            current_card = @current_account.card[answer.to_i - 1]
            loop do
              puts 'Input the amount of money you want to put on your card'
              a2 = read_input
              if a2.to_i > 0
                if put_tax(current_card[:type], current_card[:balance], current_card[:number], a2.to_i) >= a2.to_i
                  puts 'Your tax is higher than input amount'
                  return
                else
                  new_money_amount = current_card[:balance] + a2.to_i - put_tax(current_card[:type], current_card[:balance], current_card[:number], a2.to_i)
                  current_card[:balance] = new_money_amount
                  @current_account.card[answer.to_i - 1] = current_card
                  new_accounts = []
                  accounts.each do |account|
                    if account.login == @current_account.login
                      new_accounts.push(@current_account)
                    else
                      new_accounts.push(account)
                    end
                  end
                  save(new_accounts) #Storing
                  puts "Money #{a2.to_i} was put on #{current_card[:number]}. Balance: #{current_card[:balance]}. Tax: #{put_tax(current_card[:type], current_card[:balance], current_card[:number], a2.to_i)}"
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

    def send_money
      puts 'Choose the card for sending:'

      if @current_account.card.any?
        @current_account.card.each_with_index do |c, i|
          puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        answer = read_input
        exit if answer == 'exit'
        if answer.to_i <= @current_account.card.length && answer.to_i > 0
          sender_card = @current_account.card[answer.to_i - 1]
        else
          puts 'Choose correct card'
          return
        end
      else
        puts "There is no active cards!\n"
        return
      end

      puts 'Enter the recipient card:'
      a2 = read_input
      if a2.length > 15 && a2.length < 17
        all_cards = accounts.map(&:card).flatten
        if all_cards.select { |card| card[:number] == a2 }.any?
          recipient_card = all_cards.select { |card| card[:number] == a2 }.first
        else
          puts "There is no card with number #{a2}\n"
          return
        end
      else
        puts 'Please, input correct number of card'
        return
      end

      loop do
        puts 'Input the amount of money you want to withdraw'
        a3 = read_input
        if a3.to_i > 0
          sender_balance = sender_card[:balance] - a3.to_i - sender_tax(sender_card[:type], sender_card[:balance], sender_card[:number], a3.to_i)
          recipient_balance = recipient_card[:balance] + a3.to_i - put_tax(recipient_card[:type], recipient_card[:balance], recipient_card[:number], a3.to_i)

          if sender_balance < 0
            puts "You don't have enough money on card for such operation"
          elsif put_tax(recipient_card[:type], recipient_card[:balance], recipient_card[:number], a3.to_i) >= a3.to_i
            puts 'There is no enough money on sender card'
          else
            sender_card[:balance] = sender_balance
            @current_account.card[answer.to_i - 1] = sender_card
            new_accounts = []
            accounts.each do |ac|
              if ac.login == @current_account.login
                new_accounts.push(@current_account)
              elsif ac.card.map { |card| card[:number] }.include? a2
                recipient = ac
                new_recipient_cards = []
                recipient.card.each do |card|
                  if card[:number] == a2
                    card[:balance] = recipient_balance
                  end
                  new_recipient_cards.push(card)
                end
                recipient.card = new_recipient_cards
                new_accounts.push(recipient)
              end
            end
            File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
            puts "Money #{a3.to_i}$ was put on #{sender_card[:number]}. Balance: #{recipient_balance}. Tax: #{put_tax(sender_card[:type], sender_card[:balance], sender_card[:number], a3.to_i)}$\n"
            puts "Money #{a3.to_i}$ was put on #{a2}. Balance: #{sender_balance}. Tax: #{sender_tax(sender_card[:type], sender_card[:balance], sender_card[:number], a3.to_i)}$\n"
            break
          end
        else
          puts 'You entered wrong number!\n'
        end
      end
    end

    def destroy_account
      puts 'Are you sure you want to destroy account?[y/n]'
      if read_input == 'y'
        new_accounts = []
        accounts.each do |ac|
          if ac.login == @current_account.login
          else
            new_accounts.push(ac)
          end
        end

        save(new_accounts)
      end
    end

    private
    
    def save(data)
      File.open(@file_path, 'w') { |f| f.write data.to_yaml }
    end

    def name_input
      puts 'Enter your name'
      read_input
    end

    def login_input
      puts 'Enter your login'
      read_input
    end

    def password_input
      puts 'Enter your password'
      read_input
    end

    def age_input
      puts 'Enter your age'
      read_input
    end

    def accounts
      if File.exists?(@file_path)
        YAML.load_file(@file_path)
      else
        []
      end
    end

    def withdraw_tax(type, balance, number, amount)
      if type == 'usual'
        return amount * 0.05
      elsif type == 'capitalist'
        return amount * 0.04
      elsif type == 'virtual'
        return amount * 0.88
      end
      0
    end

    def put_tax(type, balance, number, amount)
      if type == 'usual'
        return amount * 0.02
      elsif type == 'capitalist'
        return 10
      elsif type == 'virtual'
        return 1
      end
      0
    end

    def sender_tax(type, balance, number, amount)
      if type == 'usual'
        return 20
      elsif type == 'capitalist'
        return amount * 0.1
      elsif type == 'virtual'
        return 1
      end
      0
    end

    def read_input
      gets.chomp
    end
  end
end
