require_relative 'person'

class Student < Person
  def initialize(classroom, age, name = 'Unknown', parent_permission: true)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
  end

  attr_accessor :classroom

  def play_hooky
    "¯\(ツ)/¯"
  end
end
