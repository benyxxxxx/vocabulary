class AddLastdelayToWords < ActiveRecord::Migration
  def change
    add_column :words, :lastdelay, :integer, :default => "0"
  end
end
