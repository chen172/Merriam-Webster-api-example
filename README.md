# Get words audio from Merriam Webster
See [Website](https://chen172.github.io/) for [Word Power Made Easy Audio](https://chen172.github.io/Word_Power_Made_Easy_Audio.html) and [Merriam-Webster's Vocabulary Builder Audio](https://chen172.github.io/Merriam-Webster's_Vocabulary_Builder_Audio.html)

## Usage
1. Create a XX.txt file contains words. 

2. Run `ruby pronunciation.rb XX.txt` to get needed files, prs_XX.txt, audio_XX.txt, audio files for the words in XX.txt.
3. Run `ruby generate_webpage_audio.erb XX.txt` to get a webpage.

## How to get a XX.txt file as the input file
* You can create by yourself. (Note: one line a word and start with '#' will be skip)
* Or you can get a XX.txt file from [Word Power Made Easy](https://github.com/chen172/chen172.github.io/tree/main/Word_Power_Made_Easy/words) or [Merriam-Webster's Vocabulary Builder](https://github.com/chen172/chen172.github.io/tree/main/Merriam-Webster's_Vocabulary_Builder/words)

##### Ruby Version
ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux-gnu]
