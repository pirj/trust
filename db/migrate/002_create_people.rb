migration 2, :create_people do
  up do
    create_table :people do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :bio, String, :length => 255
      column :photo, String, :length => 255
      column :moderated, 'Boolean'
      column :creator_id, Integer
      column :total, Integer
    end
  end

  down do
    drop_table :people
  end
end
