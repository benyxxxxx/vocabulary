class Kanji < ActiveRecord::Base
#belongs_to :word
  has_and_belongs_to_many :words

def getWords
  #Word.joins(:kanjis).where(kanjis: {kanji: self.kanji});
  self.words
end

end
