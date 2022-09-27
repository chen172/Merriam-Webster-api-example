require 'json'
require 'net/http'

if ARGV.empty?
	puts "You must add a filename"
	exit
end

$filename = ARGV[0]

# get the written pronunciation in Merriam-Webster format
# and get audio playback information
File.open($filename, "r") do |file|
	file.each_line {|line| $word = line.chomp

	if $word[0] == "#"
		next
	end
	
	$word = URI.encode_www_form_component($word)
	$word = $word.gsub(/\+/, '%20')	
	
	# api request
	url = URI.parse("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#$word?key=your key")
	req = Net::HTTP::Get.new url 
	begin
		res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http| http.request req}
	rescue 
		puts "retry connection"
		retry
	end	

	json = res.body 
	# check the respond
	if json[0,8] != "[{\"meta\""
		puts "Error!!!"
		puts "Please check the respond:"
		puts json
		return -1
	end
		
	$word = URI.decode_www_form_component($word)
	$word = $word.delete("-")		

	# so hard to format the json
	# relate type convert(String, Hash, Integer, Array)
	hash = JSON.parse(json)
		
# fix bug: https://www.merriam-webster.com/dictionary/per se
	# init variable
	id = ""
	prs = ""
	hash.each_entry {|entry|  
		id = entry.fetch("hwi").fetch("hw").delete("*").delete("-")
		if $word.casecmp(id) == 0
# fix issue: https://github.com/chen172/Merriam-Webster-api-example/issues/7
			if entry.fetch("hwi").has_key?("prs")
				prs = entry.fetch("hwi").fetch("prs")
				break
			end
		end
	}
		
# fix issue: https://github.com/chen172/Merriam-Webster-api-example/issues/5		
	if $word.casecmp(id) != 0
		if hash[0].has_key?("ins")
			hash[0].fetch("ins").each_entry {|entry|  
			id = entry.fetch("if").delete("*").delete("-") 
			if $word.casecmp(id) == 0
				prs = entry.fetch("prs" )
				break
			end
			}
		end
	end
		
# fix issue: https://github.com/chen172/Merriam-Webster-api-example/issues/2
	if $word.casecmp(id) != 0
		if hash[0].has_key?("uros")
			hash[0].fetch("uros").each_entry {|entry|  
			id = entry.fetch("ure").delete("*").delete("-") 
			if $word.casecmp(id) == 0
				prs = entry.fetch("prs" )
				break
			end
			}
		end
	end

# fix bug: https://www.merriam-webster.com/dictionary/obstetrical
	if $word.casecmp(id) != 0
		if hash[0].has_key?("vrs")
			id = hash[0].fetch("vrs")[0].fetch("va").delete("*").delete("-")
			prs = hash[0].fetch("vrs")[0].fetch("prs")
		end
	end

# fix issue: https://github.com/chen172/Merriam-Webster-api-example/issues/3
	if $word.casecmp(id) != 0
		id = hash[0].fetch("uros")[0].fetch("vrs")[0].fetch("va").delete("*").delete("-")
		if $word.casecmp(id) == 0
			prs = hash[0].fetch("uros")[0].fetch("vrs")[0].fetch("prs")
		end
	end

	$mw = prs[0].fetch("mw")
	prs.each_entry { |entry|
		if entry.has_key?("sound")
			$base_filename = entry.fetch("sound").fetch("audio")
			break
		end
	}
	
	# get word subdirectory
	$subdirectory = $base_filename[0]
	if ($base_filename[0].to_i > 0) or $base_filename[0] == '_'
		$subdirectory = "number"
	elsif $base_filename[0] == 'g' and $base_filename[1] == 'g'
		$subdirectory = "gg"
	elsif $base_filename[0] == 'b' and $base_filename[1] == 'i' and $base_filename[1] == 'x'
		$subdirectory = "bix"
	else 
		$subdirectory = $base_filename[0]
	end
	
	# get the audio file path
	audio = "https://media.merriam-webster.com/audio/prons/en/us/mp3/#$subdirectory/#$base_filename.mp3"
	
	# print information to screen
	puts $mw
	puts audio

	# save audio 
	url = URI.parse(audio)
	req = Net::HTTP::Get.new url 
	begin
		res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http| http.request req}
	rescue 
		puts "retry connection"
		retry
	end
	
	aFile = File.new("#$base_filename.mp3", "w+")
	if aFile
		aFile.syswrite(res.body)
	else
		puts "Unable to open file!"
	end

	# save prs 
	filename_prs = "prs_" + $filename
	aFile = File.new(filename_prs, "a+")
	if aFile
		aFile.syswrite($mw+"\n")
	else
		puts "Unable to open file!"
	end

	# save audio file name
	filename_audio = "audio_" + $filename
	aFile = File.new(filename_audio, "a+")
	if aFile
		aFile.syswrite($base_filename+"\n")
	else
		puts "Unable to open file!"
	end
}
end
