require 'spec_helper'

describe "to_dos endpoint" do
  let(:auth_token) { token.auth_token }
  let(:token)      { AuthenticationToken.find_or_create_for(user) }
  let(:user) do
    User.create({
      email: Faker::Internet.email,
      password: "123123123",
      password_confirmation: "123123123",
    })
  end

  describe "GET /to_dos.json" do

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

        todos = JSON.parse(response.body)
        expect(todos.first["content"]).to eq(sample_content)
      end
    end
  end

  describe "POST /to_dos.json" do
    let(:content)  { Faker::Lorem.sentence }
    let(:due_date) { Date.today + 1.week }
    let(:priority) { 3 }
    let(:data) do
      {
        content: content,
        priority: priority,
        due_date: due_date
      }
    end
    let(:to_do) do
      ToDo.create({
        content: Faker::Lorem.sentence,
        user_id: user.id,
        priority: 1,
        due_date: Date.today + 2.days
      })
    end

    context "with valid data" do
      it "creates a new record" do
        expect {
          post to_dos_path(format: "json"), { :auth_token => auth_token, :to_do => data }
        }.to change(ToDo, :count).by(1)
      end

      it "returns 204 response status" do
        post to_dos_path(format: "json"), { :auth_token => auth_token, :to_do => data }

        expect(response.status).to eq(201)
      end

    end

    context "with invalid data" do
      let(:content) { "" } # just enough to fire validation error

      it "does not create a new record" do
        expect {
          post to_dos_path(format: "json"), { :auth_token => auth_token, :to_do => data }
        }.not_to change(ToDo, :count)
      end

      it "returns validation errors" do
        post to_dos_path(format: "json"), { :auth_token => auth_token, :to_do => data }

        expected_response = "{\"errors\":{\"content\":[\"can't be blank\",\"is too short (minimum is 1 characters)\"]}}"
        expect(response.body).to eq(expected_response)
      end

      it "returns 422 response status" do
        post to_dos_path(format: "json"), { :auth_token => auth_token, :to_do => data }

        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /to_dos/:id.json" do
    context "with existing record" do
      let!(:to_do) do
        ToDo.create({
          content: Faker::Lorem.sentence,
          user_id: user.id,
          priority: 1,
          due_date: Date.today + 2.days
        })
      end

      it "returns HTTP 200" do
        delete to_do_path(to_do, format: "json"), { :auth_token => auth_token }

        expect(response.status).to eq(204)
      end

      it "deletes ToDo" do
        expect {
          delete to_do_path(to_do, format: "json"), { :auth_token => auth_token }
        }.to change(ToDo, :count).by(-1)
      end
    end
  end

  describe "PATCH /to_dos/:id.json" do
    context "without existing record" do
      it "returns HTTP 404 not found" do
        patch to_do_path(1, format: "json"), { :auth_token => auth_token }

        expect(response.status).to eq(404)
      end
    end

    context "with existing record" do
      let(:to_do) do
        ToDo.create({
          content: Faker::Lorem.sentence,
          user_id: user.id,
          priority: 1,
          due_date: Date.today + 2.days
        })
      end

      context "marking as complete" do
        it "returns success response" do
          patch to_do_path(to_do, format: "json"), { :auth_token => auth_token, :to_do => { completed: true } }

          expect(response.status).to eq(204)
        end

        it "sets record completed field to true" do
          patch to_do_path(to_do, format: "json"), { :auth_token => auth_token, :to_do => { completed: true } }

          to_do.reload

          expect(to_do.completed).to be_true
        end
      end

      context "changing priority" do
        let(:new_priority) { 3 }

        it "returns success response" do
          patch to_do_path(to_do, format: "json"), { :auth_token => auth_token, :to_do => { priority: new_priority } }

          expect(response.status).to eq(204)
        end

        it "sets record priority field to requested value" do
          patch to_do_path(to_do, format: "json"), { :auth_token => auth_token, :to_do => { priority: new_priority } }

          to_do.reload

          expect(to_do.priority).to eq(new_priority)
        end
      end

      context "changing due_date" do
        let(:new_due_date) { Date.today + 1.week }

        it "returns success response" do
          patch to_do_path(to_do, format: "json"), { :auth_token => auth_token, :to_do => { due_date: new_due_date } }

          expect(response.status).to eq(204)
        end

        it "sets record due_date field to new due date" do
          patch to_do_path(to_do, format: "json"), { :auth_token => auth_token, :to_do => { due_date: new_due_date } }

          to_do.reload

          expect(to_do.due_date).to eq(new_due_date)
        end

      end
    end
  end
end
