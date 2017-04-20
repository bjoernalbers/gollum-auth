require 'spec_helper'

module Gollum::Auth
  describe User do
    subject { build(:user) }

    it 'has valid factory' do
      expect(subject).to be_valid
    end

    describe '.find_by_credentials' do
      subject { described_class }
      let!(:user) { create(:user, username: 'monty', password: '12345') }

      after do
        described_class.delete_all
      end

      it 'returns user when user exists and password is valid' do
        expect(subject.find_by_credentials(%w(monty 12345))).to eq user
      end

      it 'returns nil when user exists but password is invalid' do
        expect(subject.find_by_credentials(%w(monty wrong))).to be nil
      end

      it 'returns nil when user does not exist' do
        expect(subject.find_by_credentials(%w(rick 12345))).to be nil
      end
    end

    describe '.find' do
      subject { described_class }
      let!(:user) { create(:user) }

      context 'when username is found' do
        it 'returns user' do
          expect(subject.find(user.username)).to eq user
        end
      end

      context 'when username is not found' do
        it 'returns nil' do
          expect(subject.find('chunkybacon')).to be nil
        end
      end
    end

    describe '#username' do
      it 'must be present' do
        subject.username = nil
        expect(subject).to be_invalid
      end

      it 'must not include german umlauts' do
        subject.username = "Björn"
        expect(subject).to be_invalid
      end
    end

    describe '#password=' do
      subject { described_class.new }

      it 'sets password_digest' do
        expect(subject.password_digest).not_to be_present
        subject.password = '123'
        expect(subject.password_digest).to eq Digest::SHA256.hexdigest('123')
      end

      it 'converts integer to strings' do
        expect(subject.password_digest).not_to be_present
        subject.password = 123
        expect(subject.password_digest).to eq Digest::SHA256.hexdigest('123')
      end
    end

    describe '#password_digest' do
      it 'must be present' do
        subject.password_digest = nil
        expect(subject).to be_invalid
      end

      it 'must include only lowercase hex chars' do
        [
          '2C26B46B68FFC68FF99B453C1D30413413422D706483BFA0F98A5E886266E7AE',
          '#-.!_,6b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae',
          'äc26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae'
        ].each do |digest|
          subject.password_digest = digest
          expect(subject).to be_invalid
        end
      end

      it 'must be 64 chars long' do
        [
          '2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7a',
          '2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7aef'
        ].each do |digest|
          subject.password_digest = digest
          expect(subject).to be_invalid
        end
      end
    end

    describe '#name' do
      it 'must be present' do
        subject.name = nil
        expect(subject).to be_invalid
      end
    end

    describe '#email' do
      it 'must be present' do
        subject.email = nil
        expect(subject).to be_invalid
      end
    end

    describe '#save!' do
      context 'when saveable' do
        before do
          allow(subject).to receive(:save) { subject }
        end

        it 'does not raise error' do
          expect { subject.save! }.not_to raise_error
        end

        it 'returns self' do
          expect(subject.save!).to eq subject
        end
      end

      context 'when not saveable' do
        before do
          allow(subject).to receive(:save) { nil }
          allow(subject).to receive(:error_message) { 'Oops!' }
        end

        it 'raises error' do
          expect { subject.save! }.to raise_error StandardError, /oops/i
        end
      end
    end

    describe '#save' do
      context 'when invalid' do
        before do
          subject.username = nil
        end

        it 'is invalid' do
          expect(subject).to be_invalid
        end

        it 'does not save object' do
          expect { subject.save }.
            not_to change { described_class.all.count }
        end

        it 'returns false' do
          expect(subject.save).to eq false
        end
      end

      context 'when valid' do
        it 'is valid' do
          expect(subject).to be_valid
        end

        it 'saves object' do
          expect { subject.save }.
            to change { described_class.all.count }.by(1)
        end

        it 'returns true' do
          expect(subject.save).to eq true
        end
      end
    end

    describe '#valid_password?' do
      subject { build(:user, password: 'topsecret') }

      context 'when correct' do
        it 'returns true' do
          expect(subject.valid_password?('topsecret')).to eq true
        end
      end

      context 'when incorrect' do
        it 'returns false' do
          expect(subject.valid_password?('wrongpassword')).to eq false
        end
      end
    end
  end
end
