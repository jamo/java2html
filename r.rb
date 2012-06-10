#!/usr/bin/env ruby
require 'fileutils'
require 'find'
require 'cgi'
include FileUtils
include Find
 if !ARGV[0] || !ARGV[1] || ['-h', '--help'].include?(ARGV[0])
   puts"Creates a new project from the project template."
   puts
   puts "Usage: #{__FILE__} [category/]project-name"
   puts
   exit 0
 end

dest_path = ARGV[0]
html_file_name = ARGV[1]

js2 = "if(!this.sh_languages){this.sh_languages={}}sh_languages.java=[[[/\b(?:import|package)\b/g,\"sh_preproc\",-1],[/\/\/\//g,\"sh_comment\",1],[/\/\//g,\"sh_comment\",7],[/\/\*\*/g,\"sh_comment\",8],[/\/\*/g,\"sh_comment\",9],[/\b[+-]?(?:(?:0x[A-Fa-f0-9]+)|(?:(?:[\d]*\.)?[\d]+(?:[eE][+-]?[\d]+)?))u?(?:(?:int(?:8|16|32|64))|L)?\b/g,\"sh_number\",-1],[/\"/g,\"sh_string\",10],[/'/g,\"sh_string\",11],[/(\b(?:class|interface))([ \t]+)([$A-Za-z0-9_]+)/g,[\"sh_keyword\",\"sh_normal\",\"sh_classname\"],-1],[/\b(?:abstract|assert|break|case|catch|class|const|continue|default|do|else|extends|false|final|finally|for|goto|if|implements|instanceof|interface|native|new|null|private|protected|public|return|static|strictfp|super|switch|synchronized|throw|throws|true|this|transient|try|volatile|while)\b/g,\"sh_keyword\",-1],[/\b(?:int|byte|boolean|char|long|float|double|short|void)\b/g,\"sh_type\",-1],[/~|!|\%|\^|\*|\(|\)|-|\+|=|\[|\]|\\|:|;|,|\.|\/|\?|&|<|>|\|/g,\"sh_symbol\",-1],[/\{|\}/g,\"sh_cbracket\",-1],[/(?:[A-Za-z]|_)[A-Za-z0-9_]*(?=[ \t]*\()/g,\"sh_function\",-1],[/([A-Za-z](?:[^`~!@#$\%&*()_=+{}|;:\",<.>\/?'\\[\]\^\-\s]|[_])*)((?:<.*>)?)(\s+(?=[*&]*[A-Za-z][^`~!@#$\%&*()_=+{}|;:\",<.>\/?'\\[\]\^\-\s]*\s*[`~!@#$\%&*()_=+{}|;:\",<.>\/?'\\[\]\^\-\[\]]+))/g,[\"sh_usertype\",\"sh_usertype\",\"sh_normal\"],-1]],[[/$/g,null,-2],[/(?:<?)[A-Za-z0-9_\.\/\-_~]+@[A-Za-z0-9_\.\/\-_~]+(?:>?)|(?:<?)[A-Za-z0-9_]+:\/\/[A-Za-z0-9_\.\/\-_~]+(?:>?)/g,\"sh_url\",-1],[/<\?xml/g,\"sh_preproc\",2,1],[/<!DOCTYPE/g,\"sh_preproc\",4,1],[/<!--/g,\"sh_comment\",5],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)(?:\/)?>/g,\"sh_keyword\",-1],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)/g,\"sh_keyword\",6,1],[/&(?:[A-Za-z0-9]+);/g,\"sh_preproc\",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*(?:\/)?>/g,\"sh_keyword\",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*/g,\"sh_keyword\",6,1],[/@[A-Za-z]+/g,\"sh_type\",-1],[/(?:TODO|FIXME|BUG)(?:[:]?)/g,\"sh_todo\",-1]],[[/\?>/g,\"sh_preproc\",-2],[/([^=\" \t>]+)([ \t]*)(=?)/g,[\"sh_type\",\"sh_normal\",\"sh_symbol\"],-1],[/\"/g,\"sh_string\",3]],[[/\\(?:\\|\")/g,null,-1],[/\"/g,\"sh_string\",-2]],[[/>/g,\"sh_preproc\",-2],[/([^=\" \t>]+)([ \t]*)(=?)/g,[\"sh_type\",\"sh_normal\",\"sh_symbol\"],-1],[/\"/g,\"sh_string\",3]],[[/-->/g,\"sh_comment\",-2],[/<!--/g,\"sh_comment\",5]],[[/(?:\/)?>/g,\"sh_keyword\",-2],[/([^=\" \t>]+)([ \t]*)(=?)/g,[\"sh_type\",\"sh_normal\",\"sh_symbol\"],-1],[/\"/g,\"sh_string\",3]],[[/$/g,null,-2]],[[/\*\//g,\"sh_comment\",-2],[/(?:<?)[A-Za-z0-9_\.\/\-_~]+@[A-Za-z0-9_\.\/\-_~]+(?:>?)|(?:<?)[A-Za-z0-9_]+:\/\/[A-Za-z0-9_\.\/\-_~]+(?:>?)/g,\"sh_url\",-1],[/<\?xml/g,\"sh_preproc\",2,1],[/<!DOCTYPE/g,\"sh_preproc\",4,1],[/<!--/g,\"sh_comment\",5],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)(?:\/)?>/g,\"sh_keyword\",-1],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)/g,\"sh_keyword\",6,1],[/&(?:[A-Za-z0-9]+);/g,\"sh_preproc\",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*(?:\/)?>/g,\"sh_keyword\",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*/g,\"sh_keyword\",6,1],[/@[A-Za-z]+/g,\"sh_type\",-1],[/(?:TODO|FIXME|BUG)(?:[:]?)/g,\"sh_todo\",-1]],[[/\*\//g,\"sh_comment\",-2],[/(?:<?)[A-Za-z0-9_\.\/\-_~]+@[A-Za-z0-9_\.\/\-_~]+(?:>?)|(?:<?)[A-Za-z0-9_]+:\/\/[A-Za-z0-9_\.\/\-_~]+(?:>?)/g,\"sh_url\",-1],[/(?:TODO|FIXME|BUG)(?:[:]?)/g,\"sh_todo\",-1]],[[/\"/g,\"sh_string\",-2],[/\\./g,\"sh_specialchar\",-1]],[[/'/g,\"sh_string\",-2],[/\\./g,\"sh_specialchar\",-1]]];"



@to_html = %Q{<!DOCTYPE HTML>\n<html>\n<meta charset="utd-8">\n<title>#{dest_path}</title>\n<script type="text/javascript" >#{js}</script></head>\n<body>}
@inside = ""
def find_all_files dest_path
  filetype = "java"
  excludes = ["CVS","classes","images","lib","tlds"]
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
  @inside << %Q{<pre class = "sh_java">\n}
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
