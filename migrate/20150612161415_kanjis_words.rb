class KanjisWords < ActiveRecord::Migration
  def change
    create_table 'kanjis_words', :id => false do |t|
      t.column :word_id, :integer
      t.column :kanji_id, :integer
    end
  end
end
