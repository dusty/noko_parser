module Fruits; end
module Animals; end

class Fruits::Banana
  include NokoParser::Properties
  nodes :xpath => '//banana'
  
  property :id, :xpath => 'id'
  property :size, :xpath => 'size'
  
end


class Animals::Monkey
  include NokoParser::Properties
  nodes :xpath => '//monkey'
  
  property :id, :xpath => '.', :attribute => 'id'

  property :first_name, :xpath => 'contact/name[@type="first"]'
  
  property :last_name, :xpath => 'contact/name[@type="last"]'

  property :age, :xpath => 'yrsold'
        
  property :funny, :xpath => 'personality', :attribute => :hilarious
        
  property :loud, :xpath => 'personality'
        
  property :street, :xpath => 'street'

  property :city, :xpath => 'city'

  property :state, :xpath => 'state'

  property :zip, :xpath => 'zip'
  
  embed :bananas, :xpath => 'bananas', :class => 'Fruits::Banana'

  def address
    [street, city, state].compact.join(", ") + " #{zip}"
  end
  
  def age
    @age.to_i
  end

  def funny=(value)
    @funny = (value == "true" ? true : false)
  end
end
