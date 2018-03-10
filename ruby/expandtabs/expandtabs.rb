# An old post from ruby-talk.
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/72682

# > Anybody have a test suite?

# No but here's the test script I've been using. It has all the different
# methods from the FAQ and the ones posted here. Your method works on my test
# data.

def method1(s)
  def sub_line(a)
    1 while a.sub!(/(^[^\t]*)\t(\t*)/){$1+' '*(8-$1.size%8+8*$2.size)}
    a
  end

  result = ""
  s.each { |line| result << sub_line(line) }
  result
end

def method2(s)
  def sub_line(a)
    1 while a.sub!(/\t(\t*)/){' '*(8-$~.begin(0)%8+8*$1.size)}
    a
  end

  result = ""
  s.each { | line | result << sub_line(line) }
  result
end

def method3(s)
  def sub_line(a)
    a.gsub!(/([^\t]{8})|([^\t]*)\t/n){[$+].pack("A8")}
    a
  end

  result = ""
  s.each { | line | result << sub_line(line) }
  result
end

def method4(a)
  b = ''
  l = 1
  0.upto(a.length) { |i|
    case a[i]
    when 9
      b += ' '
      l += 1
      while l % 8 != 0
        b += ' '
        l += 1
      end
    when 10
      b += a[i..i]
      l = 1
    else
      b += a[i..i]
      l += 1
    end
  }
  return b
end

def method5(data, indent=8)
    x = 0
    i = 0
    while i < data.length
        case data[i]
        when 9
            add = indent - (x % indent)
            data[i..i] = ' '*add
            x += add
            i += add
        when 10
            x = 0
            i += 1
        else
            x += 1
            i += 1
        end
    end
    data
end

def method6(data, indent=8)
  data.gsub(/([^\t\n]*)\t/) {
    $1 + " " * (indent - ($1.size % indent))
  }
end

def println(*s)
  print s, "\n"
end

string = ""
(0..10).each {|n|
  string << "blah\t" + (" " * n) + "blah\n"
}
(0..10).each {|n|
  string << "blah" + (" " * n) + "\tblah\n"
}

println "-- original string"
println(string)

# construct correct answer from method1
$correct = method1(string.clone)

def test_it(result)
  print result
  if result == $correct
    println "result is correct"
  else
    println "result in incorrect"
  end
  println
end

println "-- method2"
test_it(method2(string.clone))

println "-- method3"
test_it(method3(string.clone))

println "-- method4"
test_it(method4(string.clone))

println "-- method5"
test_it(method5(string.clone))

println "-- method6"
test_it(method6(string.clone))

# Sorry about my code. I'm just learning Ruby. What's the opposite of split?
