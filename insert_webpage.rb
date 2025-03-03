if ARGV.empty?
	puts "Usage: #{__FILE__} words.html"
	exit
end

$filename = ARGV[0]

# insert style for <p> tag
i = 0
data = Array.new
File.open($filename, "r") do |file|
    file.each_line {|line|
    data[i] = line
    if line.include?("</head>")
        i = i + 1
        data[i] = "	<style>\n"
        i = i + 1
        data[i] = "		p {color: #0061f2; font-size: large; margin: auto; width: 50%;}\n"
        i = i + 1
        data[i] = "	</style>\n"
    end
    i = i + 1
    } 
end

# write(overwrite) data to original file
File.write($filename, data.join, mode: "w")
