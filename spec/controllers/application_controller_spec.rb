require 'spec_helper'

describe ApplicationController do
  subject { ApplicationController.new }

  controller do
    def index
      render nothing: true, status: :success
    end
  end

  describe "#authenticate_by_token" do

    context "when auth_token param is passed" do
      let(:auth_token) { 4.times.collect { "12345" }.join }
      let(:user)       { double(User) }
      let(:params) do
        {
          auth_token: auth_token
        }
      end

      context "and token is present in the db" do
        let(:token) { double(AuthenticationToken, user: user) }

        before do
          controller.stub(:sign_in)
          AuthenticationToken.stub(:find_by_auth_token).and_return(token)
        end

        it "signs in the user" do
          expect(controller).to receive(:sign_in).with(:user, user)

          get :index, params
        end

        it "performs token lookup using params[:auth_token]" do
          expect(AuthenticationToken).to receive(:find_by_auth_token).with(auth_token)

          get :index, params
        end
      end

      context "and token is not present in the db" do
        it "does not sign in user" do
          expect(subject).not_to receive(:sign_in)

          get :index, params
        end
      end
    end

    context "when auth_token param is not passed" do
      let(:params) { {} }

      it "does not do token lookup" do
        expect(AuthenticationToken).not_to receive(:find_or_create_for)

        get :index, params
      end

      it "does not sign in user" do
        expect(subject).not_to receive(:sign_in)

        get :index, params
      end
    end
  end
end
