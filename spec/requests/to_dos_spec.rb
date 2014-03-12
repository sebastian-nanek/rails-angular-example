require 'spec_helper'

describe "GET /to_dos.json" do
  let(:auth_token) { "" }

  it "returns valid JSON" do
    get to_dos_path(format: "json"), { :auth_token => auth_token }
    expect { JSON.parse(response.body) }.not_to raise_exception
  end

  it "returns success response" do
    get to_dos_path(format: "json"), { :auth_token => auth_token }

    expect(response.status).to eq (200)
  end

  context "with a ToDo record stored in the DB" do
    let(:sample_content) { "sample" }
    let(:user)           { double(User, id: 42) }
    let(:todo) do
      ToDo.new({
        content:   sample_content,
        completed: false,
        due_date:  Date.today,
        user_id:   user.id
      })
    end

    before do
      todo.save!
    end

    it "returns serialized ToDos for current user" do
      get to_dos_path(format: "json"), { :auth_token => auth_token }

      todos = JSON.parse(response.body)["to_dos"]
      expect(todos.first["content"]).to eq(sample_content)
    end
  end
end
