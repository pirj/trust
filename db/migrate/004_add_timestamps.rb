migration 4, :add_timestamps do
  up do
    [:accounts, :logins, :people, :ratings].each do |table|
      modify_table table do
        add_column :created_at, DateTime
        add_column :updated_at, DateTime
        add_column :deleted_at, DateTime
      end
    end
  end

  down do
    [:accounts, :logins, :people, :ratings].each do |table|
      modify_table table do
        drop_column :created_at
        drop_column :updated_at
        drop_column :deleted_at
      end
    end
  end
end
