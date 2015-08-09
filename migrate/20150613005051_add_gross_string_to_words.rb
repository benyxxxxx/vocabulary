class AddGrossStringToWords < ActiveRecord::Migration
  def change
    add_column :words, :gross, :string
  end
end
