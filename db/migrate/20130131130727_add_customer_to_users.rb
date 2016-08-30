class AddCustomerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_customer, :boolean
    add_column :users, :customer_id, :integer
  end
end
