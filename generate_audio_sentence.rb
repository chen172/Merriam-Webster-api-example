if ARGV.length < 2
	puts "Usage: #{__FILE__} sentence.txt [words.txt] piper_dir"
	exit
end

$filename = ARGV[0]
#$words = ARGV[1]
$words = ARGV[0].gsub(/def_/, '')
#$piper_dir = ARGV[2]
$piper_dir = ARGV[1]

i = 0
data = Array.new
File.open($words, "r") do |file|
    file.each_line {|line|
        data[i] = line
        i = i + 1
    }
end

# save audio
i = 0
File.open($filename, "r") do |file|
    file.each_line {|line|
        line = line.gsub(/<\/?[^>]*>/, "").strip
        $base_filename = "def_" + data[i].strip
        puts $base_filename
        save_audio = "echo \"" + line + "\" | " + $piper_dir + "piper.exe --model " + $piper_dir+"en_US-hfc_female-medium.onnx --output_file " + "\"" + "#$base_filename.wav" + "\""
        system(save_audio)
        i = i + 1
    }
end
