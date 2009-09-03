== DESCRIPTION:

Used to parse XML files with Nokogiri


== REQUIREMENTS:

nokogiri


== INSTALL:

$ gem build noko_parser.gemspec
$ sudo gem install noko_parser-x.x.x.gem


== USAGE:

See examples/monkey.rb and examples/monkeys.xml

Say you have an xml document like below.  We are interested in extracting
the Monkey elements out of it and embed banana elements inside it.

<xml>
  <animals>
    <elephant id="3">
      <name>elephant1</name>
      <trunk>large</trunk>
    </elephant>
    <monkey id="1">
      <contact>
        <name type='first'>monkey1</name>
        <name type='last'>monkeylastname</name>
      </contact>
      <bananas>
        <banana>
          <id>1</id>
          <size>small</size>
        </banana>
        <banana>
          <id>2</id>
          <size>medium</size>
        </banana>
      </bananas>
      <yrsold>23</yrsold>
      <personality hilarious="true">quiet</personality>
      <street>300 Monkey St</street>
      <city>Cincinnati</city>
      <state>Oh</state>
      <zip>45219</zip>
    </monkey>
    <monkey id="2">
      <contact>
        <name type='first'>monkey2</name>
        <name type='last'>monkeylastname</name>
      </contact>
      <bananas>
        <banana>
          <id>3</id>
          <size>large</size>
        </banana>
        <banana>
          <id>4</id>
          <size>huge</size>
        </banana>
      </bananas>
      <yrsold>33</yrsold>
      <personality hilarious="false">loud</personality>
      <street>301 Monkey St</street>
      <city>Cincinnati</city>
      <state>Oh</state>
      <zip>45219</zip>
    </monkey>
  </animals>
</xml>



You first define your monkey and banana class and then describe the way to 
find all the nodes you are looking for and then the properties you want.  You
can also add class methods to manipulate the data.

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


You can then call the Monkey#parse method passing in xml or the 
Monkey#parse_file method passing in the path to a file.

You will receive an array of monkey objects in return.

irb(main):001:0> require 'pp'
=> true

irb(main):002:0> monkeys = Animals::Monkey.parse_file('examples/monkeys.xml')
=> #<Animals::Monkey:0x149cab8 ...>, #<Animals::Monkey:0x14992b4 ...>]

irb(main):003:0> pp monkeys.first
#<Animals::Monkey:0x149cab8
 @age="23",
 @bananas=
  [#<Fruits::Banana:0x149a3f8 @id="1", @size="small">,
   #<Fruits::Banana:0x1499b4c @id="2", @size="medium">],
 @city="Cincinnati",
 @first_name="monkey1",
 @funny=false,
 @id=1,
 @last_name="monkeylastname",
 @loud="quiet",
 @state="Oh",
 @street="300 Monkey St",
 @zip="45219">
=> nil

irb(main):004:0> pp monkeys.last
#<Animals::Monkey:0x14992b4
 @age="33",
 @bananas=
  [#<Fruits::Banana:0x1496c30 @id="3", @size="large">,
   #<Fruits::Banana:0x1496384 @id="4", @size="huge">],
 @city="Cincinnati",
 @first_name="monkey2",
 @funny=false,
 @id=2,
 @last_name="monkeylastname",
 @loud="loud",
 @state="Oh",
 @street="301 Monkey St",
 @zip="45219">
=> nil

irb(main):005:0> monkeys.first.age
=> 23

irb(main):006:0> monkeys.first.age.class
=> Fixnum

irb(main):007:0> monkeys.first.address
=> "300 Monkey St, Cincinnati, Oh 45219"

irb(main):008:0> monkeys.first.funny
=> false

irb(main):010:0> pp monkeys.first.bananas
[#<Fruits::Banana:0x149a3f8 @id="1", @size="small">,
 #<Fruits::Banana:0x1499b4c @id="2", @size="medium">]
=> nil

irb(main):004:0> pp monkeys.last.bananas
[#<Fruits::Banana:0x1496c30 @id="3", @size="large">,
 #<Fruits::Banana:0x1496384 @id="4", @size="huge">]
=> nil

== FEATURES/PROBLEMS:


== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
