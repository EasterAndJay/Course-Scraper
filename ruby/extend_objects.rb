# Add function to String class
# returns substring between two delimiters
class String
  def string_between_markers marker1, marker2
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end

# Add try method to all objects, as seen in Rails 4
# Allows silent operations of nil objects, i.e. no raised exceptions
class Object
  def try(*args, &b)
    __send__(*args, &b)
  end
end

# Returns nil if try called on nil object
# NilClass is the class of the nil singleton object
class NilClass
  def try(*args)
    nil
  end
end