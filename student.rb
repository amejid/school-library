require_relative 'person'

class Student < Person
  def initialize(classroom, age, name, parent_permission)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
  end

  attr_reader :classroom

  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end

  def play_hooky
    "¯\(ツ)/¯"
  end
end
