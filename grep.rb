#! /usr/bin/env ruby

require 'optparse'

def filter(content, pattern, options)
    if not options[:case_senstive]
        pattern = pattern.downcase
        def preproc(line)
            line.downcase
        end
    else
        def preproc(line)
            line
        end
    end
    pattern_regex = Regexp.new(pattern)
    content.select { |line|
        (pattern_regex.match(preproc(line)) != nil) ^ options[:invert]
    }
end


options = {
    :invert => false,
    :case_senstive => true,
    :fancy_regex => false       # TODO: implement this
}

OptionParser.new do |opts|

    opts.on("-i", "Case insenstive matches") do |v|
        options[:case_senstive] = false
    end

    opts.on("-v", "Invert match") do |v|
        options[:invert] = true
    end

    opts.on("-e", "Use a full regex engine") do |v|
        options[:fancy_regex] = true
    end

end.parse!

if ARGV[0] == nil
    puts "a pattern must be provided"
    exit(1)
end

if ARGV[1] == nil
    puts "an input file must be specified"
    exit(1)
end

File.open(ARGV[1], "r") { |content|

    filter(content, ARGV[0], options).each do |line|
        puts line
    end
}


