# Get words audio from Merriam Webster
See [Website](https://chen172.github.io/) for [Word Power Made Easy Audio](https://chen172.github.io/Word_Power_Made_Easy_Audio.html) and [Merriam-Webster's Vocabulary Builder Audio](https://chen172.github.io/Merriam-Webster's_Vocabulary_Builder_Audio.html)

## Prerequisite
You need provide your Merriam Webster api key in [here](https://github.com/chen172/Merriam-Webster-api-example/blob/e4db0f35eb73a6e80ef1e87342c75e51a7802047/pronunciation.rb#L28).

*Note: You can get api key from https://www.dictionaryapi.com/*

## Usage
1. Create a XX.txt file contains words. 

2. Run `ruby pronunciation.rb XX.txt` to get needed files, prs_XX.txt, audio_XX.txt, audio files for the words in XX.txt.
3. Run `ruby generate_webpage_audio.erb XX.txt` to generate a webpage.
4. Run `ruby generate_webpage_index_by_root.erb` to generate webpage `Merriam-Webster's_Vocabulary_Builder_Audio.html`.
5. Run `ruby generate_webpage_audio_with_root.erb XX.txt` to generate a webpage.
6. Run `for %i in (*.txt.html) do ruby insert_webpage.rb "%~i"` to insert webpages.
7. Run `for %i in (*.txt.html) do ruby extract_webpage.rb "%~i"` to extract webpages.
8. Run `for %i in (def_root*) do ruby generate_audio_sentence.rb "%~i"  piper_dir` to generate audio.

## How to get a XX.txt file as the input file
* You can create by yourself. (*Note: one line a word and start with '#' will be skip*)
* Or you can get a XX.txt file from [Word Power Made Easy](https://github.com/chen172/chen172.github.io/tree/main/Word_Power_Made_Easy/words) or [Merriam-Webster's Vocabulary Builder](https://github.com/chen172/chen172.github.io/tree/main/Merriam-Webster's_Vocabulary_Builder/words)

##### Ruby Version
ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux-gnu]
