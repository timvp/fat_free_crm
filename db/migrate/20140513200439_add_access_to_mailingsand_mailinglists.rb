class AddAccessToMailingsandMailinglists < ActiveRecord::Migration
  def change
      add_column :mailinglists, :assigned_to, :integer  
      add_column :mailinglists, :access,      :string, :limit => 8, :default => "Public"
      add_column :mailinglists, :subscribed_users, :text
      add_column :mailinglists, :user_id, :integer
      add_column :mailings, :assigned_to, :integer  
      add_column :mailings, :access,      :string, :limit => 8, :default => "Public"
      add_column :mailings, :subscribed_users, :text
      add_column :mailings, :user_id, :integer
  end
end
