class WordsKanjis < ActiveRecord::Migration
  def change
create_table 'words_kanjis', :id => false do |t|
    t.column :word_id, :integer
    t.column :kanji_id, :integer
  end
  end
end
