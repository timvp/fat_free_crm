class AddTrainingsandEvaluations < ActiveRecord::Migration
  def up
   create_table :trainings do |t|
      t.references  :user
      t.string :name
      t.date :startdate
      t.date :enddate
      t.references :account
      t.integer     :assigned_to
      t.string      :access,      :limit => 8, :default => "Public"
      t.text :subscribed_users
      t.datetime    :deleted_at
      t.timestamps
    end
    add_index :trainings, :account_id
    create_table :training_targets do |t|
      t.string :title
      t.text :description
      t.references :training
      t.datetime    :deleted_at
      t.timestamps
    end
    add_index :training_targets, :training_id
    create_table :evaluations do |t|
      t.references  :user
      t.references :training
      t.string :name
      t.integer     :assigned_to
      t.string      :access,      :limit => 8, :default => "Public"
      t.text :subscribed_users
      t.datetime    :deleted_at
      t.timestamps
    end
    create_table :training_dates do |t|
			t.date :startdate
			t.time :starttime
			t.time :duration
			t.text :remark
      t.references :training
      t.datetime    :deleted_at
      t.timestamps
    end
    create_table :registrations, :force => true do |t|
      t.references :contact
      t.references :training
      t.string     :role, :limit => 32
      t.datetime   :deleted_at
      t.timestamps
    end
    create_table :assignments, :force => true do |t|
      t.integer    :trainer_id
      t.references :training
      t.string     :role, :limit => 32
      t.timestamps
    end


  end

  def down
    drop_table :assignments
    drop_table :registrations
    drop_table :training_dates
    drop_table :training_targets
    drop_table :evaluations
    drop_table :trainings
  end
end
