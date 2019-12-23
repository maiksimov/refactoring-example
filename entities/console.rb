module Entities
  class Console
    attr_accessor :login, :file_path, :accounts
    STORAGE_FILE = 'accounts.yml'.freeze
    AGREE_COMMAND = 'y'.freeze
    EXIT_COMMAND = 'exit'.freeze
    SHOW_CARDS_COMMAND = 'SC'.freeze
    CREATE_CARD_COMMAND = 'CC'.freeze
    DELETE_CARD_COMMAND = 'DC'.freeze
    PUT_MONEY_COMMAND = 'PM'.freeze
    WITHDRAW_MONEY_COMMAND = 'WM'.freeze
    SEND_MONEY_COMMAND = 'SM'.freeze
    CREATE_ACCOUNT_COMMAND = 'create'.freeze
    LOAD_ACCOUNT_COMMAND = 'load'.freeze
    DELETE_ACCOUNT_COMMAND = 'DA'.freeze
    USUAL_CARD = 'usual'.freeze
    CAPITALIST_CARD = 'capitalist'.freeze
    VIRTUAL_CARD = 'virtual'.freeze

    def initialize
      @file_path = STORAGE_FILE
    end

    def run
      puts I18n.t('run')
      case read_input
      when CREATE_ACCOUNT_COMMAND then create_account
      when LOAD_ACCOUNT_COMMAND then load
      else
        exit
      end
    end

    def create_account
      load_accounts
      loop do
        @current_account = Entities::Account.new(name: name_input, age: age_input, login: login_input, password: password_input, accounts: @accounts)
        break if @current_account.validated?

        @current_account.errors.each do |error|
          puts error
        end
      end
      @accounts << @current_account
      save
      main_menu
    end

    def load
      load_accounts
      loop do
        if @accounts.empty?
          return create_the_first_account
        end

        puts I18n.t('enter_login')
        login = read_input
        puts I18n.t('enter_password')
        password = read_input

        if @accounts.map { |account| { login: account.login, password: account.password } }.include?({ login: login, password: password })
          @current_account = accounts.select { |account| login == account.login }.first
          break
        else
          puts I18n.t('no_account')
          next
        end
      end
      main_menu
    end

    def create_the_first_account
      puts I18n.t('no_active_accounts')
      return create_account if read_input == AGREE_COMMAND

      run
    end

    def main_menu
      loop do
        puts I18n.t('menu', name: @current_account.name)
        case read_input
        when SHOW_CARDS_COMMAND then show_cards
        when CREATE_CARD_COMMAND then create_card
        when DELETE_CARD_COMMAND then destroy_card
        when PUT_MONEY_COMMAND then put_money
        when WITHDRAW_MONEY_COMMAND then withdraw_money
        when SEND_MONEY_COMMAND then send_money
        when DELETE_ACCOUNT_COMMAND
          destroy_account
          exit
        when EXIT_COMMAND
          exit
          break
        else
          puts I18n.t('wrong_command')
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
               when USUAL_CARD
                 Card.new(
                     type: USUAL_CARD,
                     number: 16.times.map{rand(10)}.join,
                     balance: 50.00
                 )
               when CAPITALIST_CARD
                 Card.new(
                     type: CAPITALIST_CARD,
                     number: 16.times.map{rand(10)}.join,
                     balance: 100.00
                 )
               when VIRTUAL_CARD
                 Card.new(
                     type: VIRTUAL_CARD,
                     number: 16.times.map{rand(10)}.join,
                     balance: 150.00
                 )
               else
                 puts I18n.t('wrong_card_type')
                 next
               end

        @current_account.card << card
        save
        break
      end
    end

    def destroy_card
      loop do
        if @current_account.card.any?
          puts I18n.t('delete_question')

          @current_account.card.each_with_index do |card, i|
            puts I18n.t('select_card', card_number: card.number, card_type: card.type, index: (i + 1))
          end
          puts I18n.t('exit')
          answer = read_input
          break if answer == EXIT_COMMAND

          if answer.to_i <= @current_account.card.length && answer.to_i > 0
            puts "Are you sure you want to delete #{@current_account.card[answer.to_i - 1].number}?[y/n]"
            a2 = read_input
            if a2 == 'y'
              @current_account.card.delete_at(answer.to_i - 1)
              save
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
        @current_account.card.each do |card|
          puts "- #{card.number}, #{card.type}"
        end
      else
        puts "There is no active cards!\n"
      end
    end

    def withdraw_money
      puts 'Choose the card for withdrawing:'
      answer, a2, a3 = nil #answers for read_input
      if @current_account.card.any?
        @current_account.card.each_with_index do |card, i|
          puts "- #{card.number}, #{card.type}, press #{i + 1}"
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
                money_left = current_card.balance - a2.to_i - withdraw_tax(current_card.type, current_card.balance, current_card.number, a2.to_i)
                if money_left > 0
                  current_card.balance = money_left
                  @current_account.card[answer.to_i - 1] = current_card
                  # new_accounts = []
                  # @accounts.each do |ac|
                  #   if ac.login == @current_account.login
                  #     new_accounts.push(@current_account)
                  #   else
                  #     new_accounts.push(ac)
                  #   end
                  # end
                  # @accounts = new_accounts
                  save
                  puts "Money #{a2.to_i} withdrawed from #{current_card.number}$. Money left: #{current_card.balance}$. Tax: #{withdraw_tax(current_card.type, current_card.balance, current_card.number, a2.to_i)}$"
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
        @current_account.card.each_with_index do |card, i|
          puts "- #{card.number}, #{card.type}, press #{i + 1}"
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
                if put_tax(current_card.type, current_card.balance, current_card.number, a2.to_i) >= a2.to_i
                  puts 'Your tax is higher than input amount'
                  return
                else
                  new_money_amount = current_card.balance + a2.to_i - put_tax(current_card.type, current_card.balance, current_card.number, a2.to_i)
                  current_card.balance = new_money_amount
                  @current_account.card[answer.to_i - 1] = current_card

                  # new_accounts = []
                  # @accounts.each do |account|
                  #   if account.login == @current_account.login
                  #     new_accounts.push(@current_account)
                  #   else
                  #     new_accounts.push(account)
                  #   end
                  # end
                  # @accounts = new_accounts

                  save
                  puts "Money #{a2.to_i} was put on #{current_card.number}. Balance: #{current_card.balance}. Tax: #{put_tax(current_card.type, current_card.balance, current_card.number, a2.to_i)}"
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
        @current_account.card.each_with_index do |card, i|
          puts "- #{card.number}, #{card.type}, press #{i + 1}"
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
        all_cards = @accounts.map(&:card).flatten
        if all_cards.select { |card| card.number == a2 }.any?
          recipient_card = all_cards.select { |card| card.number == a2 }.first
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
          sender_balance = sender_card.balance - a3.to_i - sender_tax(sender_card.type, sender_card.balance, sender_card.number, a3.to_i)
          recipient_balance = recipient_card.balance + a3.to_i - put_tax(recipient_card.type, recipient_card.balance, recipient_card.number, a3.to_i)

          if sender_balance < 0
            puts "You don't have enough money on card for such operation"
          elsif put_tax(recipient_card.type, recipient_card.balance, recipient_card.number, a3.to_i) >= a3.to_i
            puts 'There is no enough money on sender card'
          else
            sender_card.balance = sender_balance
            @current_account.card[answer.to_i - 1] = sender_card

            new_accounts = []

            @accounts.each do |ac|
              if ac.login == @current_account.login
                new_accounts.push(@current_account)
              elsif ac.card.map { |card| card.number }.include? a2
                recipient = ac
                new_recipient_cards = []
                recipient.card.each do |card|

                  if card.number == a2
                    card.balance = recipient_balance
                  end

                  new_recipient_cards.push(card)
                end

                recipient.card = new_recipient_cards
                new_accounts.push(recipient)
              end

            end

            File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
            puts "Money #{a3.to_i}$ was put on #{sender_card.number}. Balance: #{recipient_balance}. Tax: #{put_tax(sender_card.type, sender_card.balance, sender_card.number, a3.to_i)}$\n"
            puts "Money #{a3.to_i}$ was put on #{a2}. Balance: #{sender_balance}. Tax: #{sender_tax(sender_card.type, sender_card.balance, sender_card.number, a3.to_i)}$\n"
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
        @accounts.delete_if { |account| account.login == @current_account.login }
        save
      end
    end

    def card
      @current_account.card
    end

    private
    
    def save
      File.open(@file_path, 'w') { |f| f.write @accounts.to_yaml }
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

    def load_accounts
      @accounts = File.exists?(@file_path) ? YAML.load_file(@file_path) : []
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
