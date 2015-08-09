class AddWordRefToKanji < ActiveRecord::Migration
  def change
    add_reference :kanjis, :word, index: true
    add_foreign_key :kanjis, :words
  end
end
