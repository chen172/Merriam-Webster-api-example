require 'json'

require 'net/http'



#$word = "voluminous"

#$word = "virtual"

#$word = "wokd"



$filename = "session1.txt"

File.open($filename, "r") do |file|

  file.each_line{|line| $word = line.chomp





# Get the written pronunciation in Merriam-Webster format

# And get audio playback information



url = URI.parse("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#$word?key=your key")

req = Net::HTTP::Get.new url 

res = Net::HTTP.start(url.host, url.port, 

        :use_ssl => url.scheme == 'https') {|http| http.request req}

json = res.body 



if json[0,8] != "[{\"meta\""

	puts "Error!!!"

	puts "Please check the respond:"

	puts json

	return -1

end

# So hard to format the json

# relate type convert(String, Hash, Integer, Array)

hash = JSON.parse(json)

prs = hash[0].fetch("hwi").fetch("prs")

$mw = prs[0].fetch("mw")

$base_filename = prs[0].fetch("sound").fetch("audio")

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

audio = "https://media.merriam-webster.com/audio/prons/en/us/mp3/#$subdirectory/#$base_filename.mp3"

puts $mw

puts audio



# Save prs 

filename_prs = "prs_" + $filename

aFile = File.new(filename_prs, "a+")

if aFile

   aFile.syswrite($mw+"\n")

else

   puts "Unable to open file!"

end

# Save audio file name

filename_audio = "audio_" + $filename

aFile = File.new(filename_audio, "a+")

if aFile

   aFile.syswrite($base_filename+"\n")

else

   puts "Unable to open file!"

end


# Save audio 

url = URI.parse(audio)

req = Net::HTTP::Get.new url 

res = Net::HTTP.start(url.host, url.port, 

        :use_ssl => url.scheme == 'https') {|http| http.request req}

        

aFile = File.new("#$base_filename.mp3", "w+")

if aFile

   aFile.syswrite(res.body)

else

   puts "Unable to open file!"

end



}

end

