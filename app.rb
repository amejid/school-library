require 'json'
require_relative 'student'
require_relative 'teacher'
require_relative 'book'
require_relative 'rental'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def create_person
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    choice = gets.chomp.to_i

    case choice
    when 1
      create_student
    when 2
      create_teacher
    else
      puts 'Incorrect choice'
    end
  end

  def create_book
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp

    book = Book.new(title, author)
    save_book(book)
    @books.push(book)
    puts 'Book created successfully'
  end

  def create_rental
    puts 'Select a book from the following list by number'
    list_books
    book_index = gets.chomp.to_i
    puts 'Select a person from the following list by number (not id)'
    list_people
    person_index = gets.chomp.to_i
    print 'Date: '
    date = gets.chomp

    rental = Rental.new(date, @books[book_index], @people[person_index])
    @rentals.push(rental)

    puts 'Rental created successfully'
  end

  def list_books
    return puts 'No books found!' if @books.empty?

    @books.each_with_index { |book, i| puts "#{i}) Title: #{book.title}, Author: #{book.author}" }
  end

  def list_people
    return puts 'No people found!' if @people.empty?

    @people.each_with_index do |person, i|
      puts "#{i}) [#{person.class}] Name: #{person.name}, Age: #{person.age}, ID: #{person.id}"
    end
  end

  def list_rentals
    puts 'Enter ID of the person'
    list_people
    person_id = gets.chomp.to_i
    person = @people.select { |p| p.id == person_id }[0]
    person.rentals.each_with_index { |rental, i| puts "#{i}) Book: #{rental.book.title}, Date: #{rental.date}" }
  end

  def save_book(book)
    if File.exist?('books.json')
      books_loaded = JSON.parse(File.read('books.json'))
      books_loaded << { title: book.title, author: book.author }
      File.write('books.json', JSON.pretty_generate(books_loaded))
    else
      File.write('books.json', JSON.pretty_generate([{ title: book.title, author: book.author }]))
    end
  end

  def load_books
    return unless File.exist?('books.json')

    books_loaded = JSON.parse(File.read('books.json'))
    books_loaded.each do |book|
      new_book = Book.new(book['title'], book['author'])
      @books << new_book
    end
  end

  def save_person(person)
    new_person = nil
    if person.instance_of? Student
      new_person = { id: person.id, age: person.age, name: person.name, parent_permission: person.parent_permission,
                     type: 'student' }
    elsif person.instance_of? Teacher
      new_person = { id: person.id, age: person.age, name: person.name, specialization: person.specialization,
                     type: 'teacher' }
    end
    if File.exist?('people.json')
      people_loaded = JSON.parse(File.read('people.json'))
      people_loaded << new_person
      File.write('people.json', JSON.pretty_generate(people_loaded))
    else
      File.write('people.json', JSON.pretty_generate([new_person]))
    end
  end

  def load_people
    return unless File.exist?('people.json')

    people_loaded = JSON.parse(File.read('people.json'))
    people_loaded.each do |person|
      case person['type']
      when 'student'
        new_person = Student.new(nil, person['id'], person['age'], person['name'], person['parent_permission'])
        @people << new_person
      when 'teacher'
        new_person = Teacher.new(person['specialization'], person['id'], person['age'], person['name'])
        @people << new_person
      end
    end
  end

  private

  def create_student
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
    print 'Has parent permission? [Y/N]: '
    permission = gets.chomp.downcase == 'y'

    student = Student.new(nil, nil, age, name, permission)
    save_person(student)
    @people.push(student)
    puts 'Person created successfully'
  end

  def create_teacher
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
    print 'Specialization: '
    specialization = gets.chomp

    teacher = Teacher.new(specialization, nil, age, name)
    save_person(teacher)
    @people.push(teacher)
    puts 'Person created successfully'
  end
end
