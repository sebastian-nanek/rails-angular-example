require 'spec_helper'

describe AuthenticationToken do
  let(:auth_token)      { 5.times.collect { "1234" }.join }
  let(:expiration_time) { Time.zone.now + 5.minutes }
  let(:user_id)         { 42 }

  let(:user) do
    User.new({
      id:       user_id,
      email:    double,
      password: double
    })
  end

  subject do
    AuthenticationToken.new({
      auth_token: auth_token,
      expires_at: expiration_time,
      user_id:    user_id
    })
  end

  describe ".active" do
    let(:expired_token) do
      AuthenticationToken.new({
        auth_token: 8.times.collect { "4567" }.join,
        expires_at: expiration_time - 1.hour,
        user_id:    user_id
      })
    end

    before do
      subject.save
      expired_token.save
    end

    it "narrows query scope to records that expire in future" do
      expect(described_class.active).to include(subject)
    end

    it "skips expired tokens" do
      expect(described_class.active).not_to include(expired_token)
    end
  end

  describe ".find_or_create_for" do
    before do
      subject.save
      user.save
    end

    context "when no existing active token is present" do
      let(:expiration_time) { Time.zone.now - 1.year }

      it "creates a new token" do
        expect {
          described_class.find_or_create_for(user)
        }.to change(described_class, :count).by(1)
      end

      it "returns the newly created token" do
        expect(described_class.find_or_create_for(user)).
          to eq(user.authentication_tokens.last)
      end
    end

    context "when existing active token is present" do
      it "does not create a new record" do
        expect {
          described_class.find_or_create_for(user)
        }.not_to change(AuthenticationToken, :count)
      end

      it "returns existing token" do
        expect(described_class.find_or_create_for(user)).
          to eq(subject)
      end
    end
  end

  describe "#refresh" do
    before do
      subject.stub(:save)
    end

    it "changes expiration_time to 1 hour from now " do
      expected_expires_at = Time.zone.now + 1.hour

      subject.refresh!

      expect(subject.expires_at).to be_between(expected_expires_at, expected_expires_at+1.second)
    end

    it "saves the record" do
      expect(subject).to receive(:save)

      subject.refresh!
    end
  end
end

