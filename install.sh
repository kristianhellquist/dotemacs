#!/usr/bin/env ruby

# Original from http://errtheblog.com/posts/89-huba-huba

require 'fileutils'
home = File.expand_path('~')

files = Dir['*'].select{|file| 
  not (file == "install.sh" or
  file == "README" or
  file =~ /.*[~#]/ or 
  file =~ /^\./) 
}
files.each do |file|
  target = File.join(home, ".#{file}")
  source = File.expand_path(file)
  puts "Installing ~/.#{file}"
  FileUtils.ln_sf(source, target)
end
