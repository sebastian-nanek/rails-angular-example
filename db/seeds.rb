cleared_classes = [ToDo, User]
cleared_classes.each do |klass|
  klass.delete_all
end

users = [
  {
    email: "snanek@gmail.com",
    password: "123123123",
    password_confirmation: "123123123"
  },
  5.times.collect do
    {
      email: Faker::Internet.email,
      password: "123123123",
      password_confirmation: "123123123"
    }
  end
].flatten

users.each { |u| User.create!(u) }

user_ids = User.all.collect(&:id)


todos = (20 + rand(60)).times.collect {
  {
    content: Faker::Lorem.sentences.join(" "),
    due_date: Date.today + rand(22).days,
    user_id: user_ids.sample
  }
}

todos.each { |data| ToDo.new(data).save! }
