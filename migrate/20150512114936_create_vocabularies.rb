class CreateVocabularies < ActiveRecord::Migration
  def change
    create_table :vocabularies do |t|
      t.string :word
      t.date :due

      t.timestamps null: false
    end
  end
end
