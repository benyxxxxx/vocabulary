class RenameVocabulariesToWords < ActiveRecord::Migration
  def change
    def self.up
      rename_table :vocabularies, :words
    end
    
    def self.down
      rename_table :vocabularies, :words
    end
  end
end
