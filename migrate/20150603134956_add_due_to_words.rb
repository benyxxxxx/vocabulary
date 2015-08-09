class AddDueToWords < ActiveRecord::Migration
  def change
    change_column :words, :due, :date, :default => "1972-06-23"
  end
end
