require 'spec_helper'

describe ToDoSerializer do
  let(:todo) do
    ToDo.new({
      id:        1,
      content:   "sample",
      completed: false,
      priority:  1,
      user_id:   42,
    })
  end

  subject { described_class.new(todo) }

  it "maps record to its proper JSON representation" do
    expected_representation = "{\"id\":1,\"content\":\"sample\",\"due_date\":null,\"priority\":1,\"completed\":false}"
    expect(subject.to_json).to eq(expected_representation)
  end
end
