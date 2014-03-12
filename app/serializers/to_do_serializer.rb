class ToDoSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :content, :due_date, :priority, :completed
end
