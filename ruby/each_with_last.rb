#
# from An old post to ruby-talk
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/72681
#

module Enumerable
  def each_with_last
    prev = nil
    empty = true
    each { |item|
      if empty
        empty = false
      else
        yield prev,false
      end
      prev = item
    }
    if not empty
      yield prev,true
    end
  end
end

def format(a)
  result = "["
  a.each_with_last {|i, last|
    result += i.to_s
    if not last
      result += ","
    end
  }
  result += "]"
end

puts(format([1,2,3,4,5,6,7,8,9]))
puts(format([1,2]))
puts(format([1]))
puts(format([]))
