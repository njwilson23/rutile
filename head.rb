#! /usr/bin/env ruby

require 'optparse'

def head(input, n=10)
    input.first(n).each { |line| puts line }
end

options = {:n => 10}

OptionParser.new do |opts|
    opts.banner = "Usage: head [-n N]"

    opts.on("-n N", Integer, "Line count") do |v|
        options[:n] = v
    end
end.parse!

head(ARGF, n=options[:n])
