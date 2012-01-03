migration 1, :create_accounts do
  up do
    create_table :accounts do
      column :id, Integer, :serial => true
      column :role, String
    end

    create_table :logins do
      column :id, Integer, :serial => true
      column :provider, String
      column :uid, String
      column :name, String
      column :avatar, String

      column :account_id, Integer
    end
  end

  down do
    drop_table :accounts
    drop_table :logins
  end
end
