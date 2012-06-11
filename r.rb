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

js = %Q{ <link rel="stylesheet" href="stylesheets/common.css" type="text/css" media="screen, print" />
    <link rel="stylesheet" href="stylesheets/menu.css" type="text/css" media="screen" />
    <script type="text/javascript" src="javascripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="javascripts/exercises.js"></script>
    <script type="text/javascript" src="javascripts/common.js"></script>
    <script type="text/javascript" src="javascripts/shjs/sh_main.min.js"></script>
    <script type="text/javascript" src="javascripts/shjs/sh_java.min.js"></script>
    <link rel="stylesheet" href="stylesheets/shjs/sh_style.css" type="text/css" media="screen, print" /
    <link rel="stylesheet" href="stylesheets/exercises.css" type="text/css" media="screen, print" />}

@to_html = %Q{<!DOCTYPE HTML>\n<html>\n<meta charset="utf-8">\n<title>#{dest_path}</title>\n#{js}\n</script>\n</head>\n<body>}
@inside = ""
def find_all_files dest_path
  filetype = "java"
  excludes = ["classes","test","lib","tlds"]
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


all_files = Array.new
all_files += find_all_files dest_path
go_thru_files all_files


@to_html << @inside
@to_html << %Q{</body>\n</html> }

#puts @to_html

File.open html_file_name,'w+' do |f|
  f.puts @to_html
end
