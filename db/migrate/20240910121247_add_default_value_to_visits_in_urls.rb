class AddDefaultValueToVisitsInUrls < ActiveRecord::Migration[7.1]
  def change
    change_column_default :urls, :visits, 0
  end
end
