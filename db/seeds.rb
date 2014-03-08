cleared_classes = [ToDo, User]
cleared_classes.each do |klass|
  klass.delete_all
end

todos = [
  {
    content: Faker::Lorem.sentences,
    due_date: Date.today + rand(12).days,
  }
]
todos.each { |data| ToDo.new(data).save! }
