migration 6, :login_token do
  up do
    modify_table :logins do
      add_column :token, String
    end
  end

  down do
    modify_table :logins do
      drop_column :token
    end
  end
end
