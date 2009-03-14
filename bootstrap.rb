#!/usr/bin/env ruby
require 'ftools'

FILES = %w( .rake-completion.rb .bashrc .irbrc .dircolors .gitconfig .gitk )
BACKUP_DIR = '.bootstrap_backups'
USR_LOCAL_BIN = File.join('/', 'usr', 'local', 'bin')
ACK = File.join(USR_LOCAL_BIN, 'ack')

Dir.chdir(ENV["HOME"]) do
  puts "Making backup directory #{ENV["HOME"]}/#{BACKUP_DIR}"
  begin
    Dir.mkdir(BACKUP_DIR)
  rescue Errno::EEXIST
    # don't care...
  end

  puts "Making backup files:"
  FILES.each do |file|
    backup = File.join(BACKUP_DIR, "#{file}-#{Time.now.to_i}")
    puts "Moving #{file} to #{backup}"
    File.rename(file, backup) rescue nil # eat the exception... we don't care if it doesn't exist
  end
end

puts "Copying in files:"
FILES.each do |file|
  puts "Copying in #{file} to #{ENV['HOME']}"
  homefile = File.join("#{ENV['HOME']}", file)
  File.copy(file, homefile)
end

puts "Copying ack to #{USR_LOCAL_BIN} (requires sudo password)"
system "sudo cp ack #{USR_LOCAL_BIN}"
system "sudo chmod a+x #{ACK}"
