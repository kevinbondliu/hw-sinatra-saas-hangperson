class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(newguess)
    raise ArgumentError if newguess.nil?
    raise ArgumentError if newguess.empty?
    raise ArgumentError if newguess =~ /[^a-zA-Z]+/
    newguess.downcase!
    if @word.include? newguess and !@guesses.include? newguess
      @guesses.concat newguess
      return true
    elsif !@word.include? newguess and !@wrong_guesses.include? newguess
      @wrong_guesses.concat newguess
      return true
    else
      return false
    end
  end

  def word_with_guesses
    wordguess = ''
    @word.each_char do |i|
      if @guesses.include? i
        wordguess.concat i
      else
        wordguess.concat '-'
      end
    end
    return wordguess
  end

  def check_win_or_lose
    count = 0
    if @wrong_guesses.length >= 7
      return :lose
    end
    @word.each_char do |i|
      if @guesses.include? i 
        count += 1
      end
    end
    if count == @word.length
      return :win
    else
      return :play
    end
  end
  
end
