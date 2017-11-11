#! /usr/bin/env ruby

require 'optparse'

def ls(path, options)
    if not path.end_with? "/"
        path = path + "/"
    end

    files = Dir.entries(path).select { |fnm|
        options[:all] or fnm[0] != "."
    }.map { |fnm|
        File.join path, fnm
    }.sort

    maxLen = files.map { |s| File.basename(s).length }.max
    files.each do |file|
        putFile(file, options, len=maxLen+1)
    end
end

def putFile(file, options, len=20)
    output = File.basename file
    if options[:long]
        size = getSize(file, human=options[:human])
        output = output.ljust(len).slice(0, len) + "  "  + size
    end
    puts output
end

def getSize(filename, human=false)
    bytes = File.open(filename) {|f| f.size}
    if human
        if bytes > 2000000000
            outstr = (bytes / 1000000000).to_s + " GB"
        elsif bytes > 2000000
            outstr = (bytes / 1000000).to_s + " MB"
        elsif bytes > 2000
            outstr = (bytes / 1000).to_s + " kB"
        else
            outstr = bytes.to_s + " bytes"
        end
    else
        outstr = bytes.to_s
    end
    outstr
end

options = {
    :long => false,
    :human => false,
    :all => false
}

OptionParser.new do |opts|
    opts.on("-a", "Include hidden files") do |v|
        options[:all] = true
    end

    opts.on("-l", "Print details") do |v|
        options[:long] = true
    end

    opts.on("-h", "Human readable size") do |v|
        options[:human] = true
    end
end.parse!

path = ARGV[0]
if path == nil
    path = "."
end

if not File.exist? path
    puts "invalid directory '#{path}'"
    exit(1)
end

ls(path, options)

