require_relative 'app'

def call_app(app, choice)
  case choice
  when 1
    app.list_books
  when 2
    app.list_people
  when 3
    app.create_person
  when 4
    app.create_book
  when 5
    app.create_rental
  when 6
    app.list_rentals
  else
    puts 'Invalid input'
  end
end

def main
  app = App.new
  puts 'Welcome to School Library App!'

  loop do
    puts "\nPlease choose an option by enetering a number:\n1 - List all books"
    puts "2 - List all people\n3 - Create a person"
    puts "4 - Create a book\n5 - Create a rental\n6 - List all rentals for a given person id\n7 - Exit"

    choice = gets.chomp.to_i
    if choice == 7
      puts 'Thanks for using this app!'
      break
    end

    call_app(app, choice)
  end
end

main
