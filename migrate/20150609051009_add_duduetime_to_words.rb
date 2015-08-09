class AddDuduetimeToWords < ActiveRecord::Migration
  def change
    change_column :words, :duetime, :datetime, :default => '00:00:00'
  end
end
