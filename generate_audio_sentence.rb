if ARGV.length < 2
	puts "Usage: #{__FILE__} words.txt piper_dir"
	exit
end

$words = ARGV[0]
$def_words = "def_" + ARGV[0]
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
File.open($def_words, "r") do |file|
    file.each_line {|line|
        line = line.gsub(/<\/?[^>]*>/, "").strip
        if line == "Number Words" or line == "Medical Words"
            i = i + 1
            next
        end
        $audio_filename = "def_" + data[i].strip.gsub(/\//, '_')
        puts $audio_filename
        save_audio = "echo \"" + line + "\" | " + $piper_dir + "piper.exe --model " + $piper_dir+"en_US-hfc_female-medium.onnx --output_file " + "\"" + "#$audio_filename.wav" + "\""
        system(save_audio)
        i = i + 1
    }
end
