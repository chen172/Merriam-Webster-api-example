require 'json'
require 'net/http'

#$word = "voluminous"
#$word = "virtual"
#$word = "wokd"

$filename = "session11.txt"

# get the written pronunciation in Merriam-Webster format
# and get audio playback information
File.open($filename, "r") do |file|
	file.each_line {|line| $word = line.chomp
	
	# api request
	url = URI.parse("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#$word?key=f83982f5-a08d-47e9-86e3-c12560ad1123")
	req = Net::HTTP::Get.new url 
	res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http| http.request req}	

	json = res.body 
	# check the respond
	if json[0,8] != "[{\"meta\""
	puts "Error!!!"
	puts "Please check the respond:"
	puts json
	return -1
end

# so hard to format the json
# relate type convert(String, Hash, Integer, Array)
	hash = JSON.parse(json)
	prs = hash[0].fetch("hwi").fetch("prs")

# fix issue: https://github.com/chen172/Merriam-Webster-api-example/issues/2#issuecomment-1229459120
	id = id = hash[0].fetch("hwi").fetch("hw").delete("*")
	if id != $word
		hash[0].fetch("uros").each_entry {|entry|  
		id = entry.fetch("ure").delete("*") 
		if id == $word
			prs = entry.fetch("prs" )
			break
		end
		}
	end

# fix bug: https://www.merriam-webster.com/dictionary/obstetrical
	if id != $word
		if hash[0].has_key?("vrs")
			id = hash[0].fetch("vrs")[0].fetch("va").delete("*")
			prs = hash[0].fetch("vrs")[0].fetch("prs")
		end
	end

# fix issue: https://github.com/chen172/Merriam-Webster-api-example/issues/3#issuecomment-1229483723
	if id != $word
		id = hash[0].fetch("uros")[0].fetch("vrs")[0].fetch("va").delete("*")
		if id == $word
			prs = hash[0].fetch("uros")[0].fetch("vrs")[0].fetch("prs")
		end
	end

	$mw = prs[0].fetch("mw")
	$base_filename = prs[0].fetch("sound").fetch("audio")
	
	# get word subdirectory
	$subdirectory = $base_filename[0]
	if $base_filename[0].is_a?(Numeric) or $base_filename[0] == '_'
		$subdirectory = "number"
	elsif $base_filename[0] == 'g' and $base_filename[1] == ''
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

	# save audio 
	url = URI.parse(audio)
	req = Net::HTTP::Get.new url 
	res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http| http.request req}
	
	aFile = File.new("#$base_filename.mp3", "w+")
	if aFile
		aFile.syswrite(res.body)
	else
		puts "Unable to open file!"
	end
}
end
