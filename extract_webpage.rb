if ARGV.empty?
	puts "Usage: #{__FILE__} words.html"
	exit
end

$filename = ARGV[0]
filename_def_root = "def_root_#$filename"
filename_def_root = filename_def_root.gsub(/.html/, '')

# extract <p> tag
i = 0
data = Array.new
File.open($filename, "r") do |file|
    file.each_line {|line|
        if line.include?("<p>")
            if line.include?("</p>")
                data[i] = line
            else
                data[i] = line.strip + "</p>\n"
            end
        end
        i = i + 1
    } 
end

# write(overwrite) data to original file
File.write(filename_def_root, data.join, mode: "w")
