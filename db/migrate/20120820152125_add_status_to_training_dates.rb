class AddStatusToTrainingDates < ActiveRecord::Migration
  def change
    add_column :training_dates, :status, :string
  end
end
