migration 7, :rating_published do
  up do
    modify_table :ratings do
      add_column :published, 'Boolean'
    end
  end

  down do
    modify_table :ratings do
      drop_column :published
    end
  end
end
