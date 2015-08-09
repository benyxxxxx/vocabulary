# -*- coding: utf-8 -*-
require 'test_helper'

class KanjiTest < ActiveSupport::TestCase
  test "the truth" do

    a = Edict.meaning "明"
    
    a.each {|g| puts g}
    
    (Edict.getpos_id "明") .each { |r|
      puts r
    }
    
    ##assert Kanji.count == 5
    ##assert Kanji.where(kanji: "i").count == 2

    ##assert Kanji.select(:kanji).distinct().count == 4
    
    ##word1 = Word.first();

    ##word2 = Word.second();

    ##assert word1.kanjis().count == 3

    ##assert word2.kanjis().count == 2
    
    ##assert Word.joins(:kanjis).where(kanjis: {kanji: "F"}).count == 1;
    ##assert Word.joins(:kanjis).where(kanjis: {kanji: "i"}).count == 2;
    ##assert Word.joins(:kanjis).where(kanjis: {kanji: "F"}).count == 1;
    
    kanjiI = Kanji.where(kanji: "食")[0];
    
    wordsI = kanjiI.getWords();
    assert Kanji.uniq.pluck(:kanji).count == 4
    assert wordsI.count == 2;

    @kanji = Kanji.third;
    @wordsOf = @kanji.getWords
    puts "Kanji #{@kanji.kanji} Words count  #{@wordsOf.count}"

    #Kanji.find_by_kanji("i") do |i|
    #  assert i.word == "s"
    #end
  end
end
