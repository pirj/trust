Trust.helpers do
  def aggregate ratings
    ratings.inject({}) do |total, rating|
      person = total[rating.person] ||= {}
      person[rating.positive] ||= 0
      person[rating.positive] += 1
      total
    end.map do |person, total|
      {:person => person.name, :plus => total[true], :minus => total[false]}
    end
  end

  def recalculate person
    positive = person.ratings(:positive => true).count
    negative = person.ratings(:positive => false).count
    person.total = positive - negative
    person.positive = positive
    person.negative = negative
    person.overall = positive + negative
    person.save
  end
end
