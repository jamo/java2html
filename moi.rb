path = ARGV[0]

strings = []
File.open path,'r' do |f1|
  while line = f1.gets
    strings << line
  end
  puts strings
end

File.open "moi",'w+' do |f2|
  strings.each { |a| f2.write a}
end
