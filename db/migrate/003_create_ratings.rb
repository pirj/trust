migration 3, :create_ratings do
  up do
    create_table :ratings do
      column :id, Integer, :serial => true
      column :person_id, Integer
      column :account_id, Integer
      column :positive, 'Boolean'
    end
  end

  down do
    drop_table :ratings
  end
end
