class Student

attr_accessor :name, :grade
attr_reader :id

def initialize(name, grade, id = nil) #initialize with name, grade, and optional id (assigned by sql when data is enetered in table)
  @name = name
  @grade = grade
  # @id = some_id
end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def self.create_table #create a table unless one exists consisting of these columns (attributes in student class)
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER
    )
    SQL
    DB[:conn].execute(sql) #execute the code on DB, the databse defined in config/environment.rb
  end

  def self.drop_table #make a drop table method. heredoc with sql drop table instructions inside, and DB[:conn].execute to run it.
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO
    students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade) #execute heredoc code on DB[:conn], inserting name and grade instance variables
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] #return id from sql table for this row. not quite sure what [0][0] makes happen.
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade) #make an instance of the class
    student.save  #save that data by calling 'save' on the instance
    student #return the instance in case you want to do something else with the newly created instance
  end

end
