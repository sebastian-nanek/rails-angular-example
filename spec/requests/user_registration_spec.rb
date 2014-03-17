require 'spec_helper'

describe "user registration endpoint" do
  describe "POST /users/register.json" do
    context "with valid data" do
      let(:data) do
        {
          user: user_data
        }
      end
      let(:user_data) do
        {
          email: Faker::Internet.email,
          password: "123123123",
          password_confirmation: "123123123",
        }
      end

      it "creates a new User" do
        expect {
          post user_registration_path(format: "json"), data
        }.to change(User, :count).by(1)
      end

      it "returns status 200" do
        post user_registration_path(format: "json"), data

        expect(response.status).to eq(201)
      end
    end

    context "with invalid data" do
      let(:data) do
        {
          user: user_data
        }
      end
      let(:user_data) do
        {
          email: "invalid@email",
          password: "1",
          password_confirmation: "2",
        }
      end

      it "returns validation errors" do
        post user_registration_path(format: "json"), data

        expected_response = "{\"errors\":{\"email\":[\"is invalid\"],\"password_confirmation\":[\"doesn't match Password\"],\"password\":[\"is too short (minimum is 8 characters)\"]}}"


        expect(response.body).to eq(expected_response)
      end

      it "returns status 422" do
        post user_registration_path(format: "json"), data

        expect(response.status).to eq(422)
      end

      it "does not create a new user" do
        expect {
          post user_registration_path(format: "json"), data
        }.not_to change(User, :count)
      end
    end
  end
end
