class AddIsResponsibleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_customer_responsible, :boolean
  end
end
