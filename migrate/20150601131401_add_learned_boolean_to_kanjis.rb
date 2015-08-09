class AddLearnedBooleanToKanjis < ActiveRecord::Migration
  def change
    add_column :kanjis, :learned, :boolean, default: :false
  end
end
