class Actor
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_actors = DB.exec("SELECT * FROM actors;")
    actors = []
    returned_actors.each() do |actor|
      name = actor.fetch("name")
      id = actor.fetch("id").to_i()
      actors.push(Actor.new({:name => name, :id => id}))
    end
    actors
  end

  define_singleton_method(:find) do |id|
    result = DB.exec("SELECT * FROM actors WHERE id = #{id};")
    name = result.first().fetch("name")
    Actor.new({:name => name, :id => id})
  end


  define_method(:save) do
    result = DB.exec("INSERT INTO actors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |another_actor|
    self.name().==(another_actor.name()).&(self.id().==(another_actor.id()))
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE actors SET name = '#{@name}' WHERE id = #{@id};")
  end

  define_method(:delete) do
    DB.exec("DELETE FROM actors WHERE id = #{self.id()};")
  end
end
