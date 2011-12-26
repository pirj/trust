migration 5, :rating_aggregates do
  up do
    modify_table :people do
      add_column :positive, Integer
      add_column :negative, Integer
      add_column :overall, Integer
    end

    Person.all.each do |person|
      person.positive = person.ratings(:positive => true).count
      person.negative = person.ratings(:positive => false).count
      person.overall = person.ratings.count
      person.save
    end
  end

  down do
    modify_table :people do
      drop_column :positive
      drop_column :negative
      drop_column :overall
    end
  end
end
