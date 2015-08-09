class AddIndexToKanjisWords < ActiveRecord::Migration
  def change
    add_index :kanjis_words, [:kanji_id, :word_id], :unique => true
    add_index :kanjis_words, :kanji_id
  end
end
