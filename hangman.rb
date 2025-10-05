require 'json'
guess_count=10
random_guess = File.readlines('lib/1000_words.txt').sample.chomp
    

def hangman(random_guess,guess_count)
  puts "\n\n Save the man from being hanged\n Enter your guess:"
  player_guess = gets.chomp
  until player_guess == random_guess
    case player_guess
    when 'savegame'
      File.write('savegame.json', JSON.dump({
        guess_count: guess_count,
        random_guess: random_guess,
        guessed_letters: guessed_letters
      }))
      puts "💾 Game saved!"
      next

    when 'resume'
      if File.exist?('savegame.json')
        stats = JSON.load(File.read('savegame.json'))
        guess_count = stats['guess_count']
        random_guess = stats['random_guess']
        guessed_letters = stats['guessed_letters']
        puts "📂 Game resumed!"
        puts "Word so far: #{random_guess.gsub(/[^#{guessed_letters.join}]/i, '_')}"
        puts "Guesses left: #{guess_count}"
      else
        puts "⚠️ No saved game found!"
      end
      next
    end

    # Handle repeated guesses
    if guessed_letters.include?(player_guess)
      puts "⚠️ You already tried '#{player_guess}'."
      next
    end
    guess_count -= 1
    puts "Wrong! #{guess_count} guesses left"
    guessed_letters= player_guess.split
    masked_word = random_guess.gsub(/[^#{guessed_letters.join}]/i, '_')
    puts masked_word
    break if guess_count < 1
    player_guess = gets.chomp
  end
  if player_guess == random_guess
    puts "You saved the man"
  else
    "💀 Hanged! The word was '#{random_guess}'."
  end
end
        

hangman(random_guess,guess_count)s