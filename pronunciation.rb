require 'json'

require 'net/http'



#$word = "voluminous"

$word = "virtual"



# Get the written pronunciation in Merriam-Webster format

# And get audio playback information



url = URI.parse("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#$word?key=your key")

req = Net::HTTP::Get.new url 

res = Net::HTTP.start(url.host, url.port, 

        :use_ssl => url.scheme == 'https') {|http| http.request req}

json = res.body 



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
