class Word < ActiveRecord::Base

  has_and_belongs_to_many :kanjis
#  validates_uniqueness_of :word
  
  def after_initialize
    self.gross =     getTranslation()[1]
  end

  def getKanjis
    #Kanji.find_by(word_id: self.word_id);
    self.kanjis
  end

  def createLinks
    self.word.each_char do |i|
      if ""+i =~ /\p{Han}/
        #unless Kanji.find_by_kanji
        kanji = Kanji.find_by_kanji(""+i)
        unless kanji != nil
          kanji = Kanji.new 
          kanji.kanji = ""+i
          kanji.save
        end
        self.kanjis << kanji;
        #end
      end
    end
  end

  def self.getAdded 
    Word.where("due = '1972-06-23'")
  end
  
  def self.setAdded
    Word.all.each() do |word|
      word.due =  '1972-06-23'
      word.save
    end
  end
  
  def self.allocateNew
    currentNewCount = Word.getNew().count;
    Word.getAdded().limit(20 - currentNewCount).each() do |word|
      word.due =  '2012-06-23'
      word.save
    end
  end


    
  def self.getNew 
    Word.where("due =  '2012-06-23'")
  end
  
  def isNew? 
    self.due == DateTime.parse('2012-06-23')
  end
  

  def isInLearn? 
    self.due == DateTime.parse('2013-06-23')
  end
  

  def self.getInLearn 
      Word.where("due = '2013-06-23'").order(:duetime);
  end

  def setInLearn(inMinutes)
    
    self.duetime = Time.current() + inMinutes.minutes
    
    self.due = '2013-06-23'

    self.lastdelay = inMinutes
  end
  
  ## 10m -> 
  def getOptions()
    ret = Hash.new(0)
    if isNew? 
      ret = {"again" => 1, "good" => 10, "easy" => 24 * 60} 
    elsif isInLearn?  
      ret = {"again" => self.lastdelay, "good" => 24 * 60} 
    else 
      ret = {"again" => 10, "hard" => self.lastdelay, 
          "good" => self.lastdelay*2, "easy" => self.lastdelay * 3} 
      
    end
    
    return ret
  end

  ##@@dues
  def self.getDue 
    ##@@dues ||= 
    Word.where("due >  '2013-06-23' AND due <= ? ", Date.today)
  end

  def isDue? 
    (self.due > Date.parse('2013-06-23')) && (self.due <= Date.today)
  end

  def self.getNewerThan(atime) 
    Word.where("created_at > ?", atime)
  end
  
  def getTranslation
    mean = Edict.meaning(word) 
    if ( mean.count == 0)
      mean = Edict.meaning_by_hiragana(word) 
    end

    if mean != nil && mean.count && mean[0] != nil
      return mean[0]
    end
    return ["", ""];
  end
  
  def getMeaning
    self.gross
  end

  def getFurigana
    #getTranslation()[0]
  end
  
  
  def incrementDue(plusDue)
    puts self.due
    if plusDue.to_i <= 10
      self.setInLearn(plusDue.to_i)
    else
      
      self.due = Date.today() + plusDue.to_i.minutes
      
      self.lastdelay = plusDue
      puts self.due
    end
  end

  
  def self.getCurrentWord
    
    word = nil

    if (Word.getInLearn.count > 0 && Word.getInLearn[0].duetime <= DateTime.now) then
      word = Word.getInLearn[0];
    elsif  (Word.getDue.count > 0) then
      word = Word.getDue[0];
    elsif (Word.getNew.count > 0) then
      word = Word.getNew[0];
    end
    if word == nil && Word.getInLearn.count > 0
      word = Word.getInLearn[0];
    end

    #p "After #{word.due}"
    
    return word
  end
  
end
