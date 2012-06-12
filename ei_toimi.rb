#!/usr/bin/env ruby
require 'fileutils'
require 'find'
require 'cgi'
include FileUtils
include Find

 if !ARGV[0] || !ARGV[1] || ['-h', '--help'].include?(ARGV[0])
   puts"Creates a new project from the project template."
   puts
   puts "Usage: #{__FILE__} [category/]project-name html_file_to_create.html"
   puts
   exit 0
 end

dest_path = ARGV[0]
html_file_name = ARGV[1]


@inside = ""
def find_all_files dest_path, filetype
  excludes = ["test","lib"]
  files = Array.new
  Find.find(dest_path) do |path|
    if FileTest.directory?(path)
      if excludes.include?(File.basename(path))
        Find.prune
      else
        next
      end
    else
      if path.end_with? filetype
        files << path
      end
    end
  end
  files
end

def add_to_HTML strings
  @inside << %Q{<pre class="sh_java">\n}
  strings.each do |string|
    @inside << string
  end
  @inside << %Q{</pre>\n}
end

def go_thru_files all_files
  strings = []
  for path in all_files
    File.open path,'r' do |f1|
      while line = f1.gets
        strings << CGI::escapeHTML(line)
      end
      add_to_HTML strings
      strings = []
    end
  end
end

def add_js all_files
  at_begin = %Q{<script type="text/javascript">}
  at_end = %Q{</script>}
  data = ""
  all_files.each do |file|
    one_js_file = ""
    File.open file, 'r' do |f1|
      while line = f1.gets
        one_js_file << line
      end
    end
    data << at_begin
    data << one_js_file
    data << at_end
    one_js_file = ""
  end
  data
end

all_js_files = Array.new

all_js_files = find_all_files '.', 'js'
puts all_js_files
#puts add_js all_js_files

js = add_js(all_js_files)

@to_html = %Q{<!DOCTYPE HTML>\n<html>\n<meta charset="utf-8">\n<title>#{dest_path}</title>\n#{js}\n</script>\n</head>\n<body>}

all_files = find_all_files dest_path, 'java'
go_thru_files all_files


@to_html << @inside
@to_html << %Q{</body>\n</html> }

#puts @to_html

File.open html_file_name,'w+' do |f|
  f.puts @to_html
end
