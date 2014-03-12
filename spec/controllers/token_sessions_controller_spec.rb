require 'spec_helper'

describe TokenSessionsController do
  describe "#create" do
    let(:email)    { Faker::Internet.email }
    let(:password) { "123123123" }
    let(:user) do
      User.new({
        email:                 email,
        password:              password,
        password_confirmation: password
      })
    end

    before do
      user.save!
    end

    context "with invalid credentials" do
      let(:error_response) { "{\"errors\":\"invalid_credentials\"}" }

      context "when invalid email passed" do
        let(:invalid_email) { "invalid_email@invalid.tld" }

        it "returns error response" do
          get(:create, format: :json, email: invalid_email, password: password)

          expect(response.body).to eq(error_response)
        end

        it "sets response status to 500" do
          get(:create, format: :json, email: invalid_email, password: password)

          expect(response.status).to eq(500)
        end
      end

      context "when invalid password passed" do
        let(:invalid_password) { "invalid_password" }

        it "returns error response" do
          get(:create, format: :json, email: email, password: invalid_password)

          expect(response.body).to eq(error_response)
        end

        it "sets response status to 500" do
          get(:create, format: :json, email: email, password: invalid_password)

          expect(response.status).to eq(500)
        end
      end
    end

    context "when currently active token found" do
      before do
        AuthenticationToken.find_or_create_for(user)
      end

      it "reuses exisitng token" do
        expect {
          get(:create, format: :json, email: email, password: password)
        }.not_to change(AuthenticationToken, :count)
      end

      it "renders user_id and token in response" do
        get(:create, format: :json, email: email, password: password)

        parsed_response = JSON.parse(response.body)
        token = user.authentication_tokens.active.last

        expect(parsed_response).to eq({"user_id" => user.id, "auth_token" => token.auth_token})
      end

      it "yields success" do
        get(:create, format: :json, email: email, password: password)

        expect(response.status).to eq(200)
      end
    end

    context "when currently inactive token found" do
      it "generates a new token" do
        expect{
          get(:create, format: :json, email: email, password: password)
        }.to change(AuthenticationToken, :count).by(1)
      end

      it "renders user_id and token in response" do
        get(:create, format: :json, email: email, password: password)

        parsed_response = JSON.parse(response.body)
        token = user.authentication_tokens.active.last

        expect(parsed_response).to eq({"user_id" => user.id, "auth_token" => token.auth_token})
      end

      it "yields success" do
        get(:create, format: :json, email: email, password: password)
        expect(response.status).to eq(200)
      end
    end
  end
end
