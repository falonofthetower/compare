class Set
  attr_reader :first, :second
  attr_accessor :libraries, :start, :finish

  def initialize(first, second)
    @first = first
    @second = second
    @libraries = []
  end

  def call
    build
    calculate
  end

  def build
    File.readlines(first).each_with_index do |item,index|
      if index.even?
        @name = item.strip.to_sym
        @library = Library.new(@name)
        @libraries << @library
      else
        @library.size_start = item.scan(/\d+/).join().to_i
      end
    end
    File.readlines(second).each_with_index do |item,index|
      if index.even?
        @name = item.strip.to_sym
        @library = @libraries.map {|l| l if l.name == @name}.compact.first ||
          Library.new(@name)
      else
        @library.size_finish = item.scan(/\d+/).join().to_i
      end
    end
  end

  def calculate
    check = @libraries.map {|l| [l.name, l.difference] if l.difference != 0 }
    check.compact.sort {|x,y| x[1] <=> y[1] }
  end
  
end

class Library
  attr_reader :name
  attr_accessor :size_start, :size_finish

  def initialize(name)
    @name = name
    @size_start = 0
    @size_finish = 0
  end

  def difference
    size_finish - size_start
  end
end

first = ARGV[0]
second = ARGV[1]
raise "you must run command like `ruby compare.rb filename1.txt filename2.txt`" unless first && second

result = Set.new(first,second).call
File.open('result.txt', 'w') do |f|
  result.each do |l|
    f.write("#{l[0]}: #{l[1]}\n")
  end
end
