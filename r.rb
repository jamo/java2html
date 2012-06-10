#!/usr/bin/env ruby
require 'fileutils'
require 'find'
require 'cgi'
include FileUtils
include Find
 if !ARGV[0] || ['-h', '--help'].include?(ARGV[0])
   puts"Creates a new project from the project template."
   puts
   puts "Usage: #{__FILE__} [category/]project-name"
   puts
   exit 0
 end

dest_path = ARGV[0]


def find_all_files dest_path
  filetype = "erb"
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

all_files = Array.new
all_files += find_all_files dest_path


def add_to_HTML strings
  puts strings
end


def go_thru_files all_files
  strings = []
  for path in all_files
    File.open path,'r' do |f1|
      while line = f1.gets
        #      do_something(line)
        strings << CGI::escapeHTML(line)
      end
      add_to_HTML strings
      strings = []
    end
  end

end

go_thru_files all_files



