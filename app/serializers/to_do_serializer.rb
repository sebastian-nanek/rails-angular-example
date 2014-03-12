class ToDoSerializer < ActiveModel::Serializer
  attributes :id, :content, :due_date, :priority, :completed
end
