migration 1, :create_accounts do
  up do
    create_table :accounts do
      column :id, Integer, :serial => true
      column :role, String

      column :provider, String
      column :uid, String
      column :name, String
      column :avatar, String
    end
  end

  down do
    drop_table :accounts
  end
end
