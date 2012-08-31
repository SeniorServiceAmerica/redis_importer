class Person
  attr_reader :id, :first_name, :last_name

  def initialize(args={})
    @id = args["id"]
    @first_name = args["first_name"]
    @last_name = args["last_name"]
  end
  
  def to_redis()
    ["hset|person:#{self.id}|first_name|#{self.first_name}", "hset|person:#{self.id}|last_name|#{self.last_name}"]
  end
end