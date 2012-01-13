migration 8, :enhance_person_lengths do
  up do
    modify_table :people do
      change_column :name, 'TYPE text'
      change_column :bio, 'TYPE text'
      change_column :photo, 'TYPE text'
    end
  end

  down do
  end
end
