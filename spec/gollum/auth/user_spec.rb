require 'spec_helper'

module Gollum::Auth
  describe User do
    subject { build(:user) }

    it 'has valid factory' do
      expect(subject).to be_valid
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

    describe '#password' do
      it 'must be present' do
        subject.password = nil
        expect(subject).to be_invalid
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

        it 'returns nil' do
          expect(subject.save).to be nil
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

        it 'returns self' do
          expect(subject.save).to eq subject
        end
      end
    end

    describe '#valid_password?' do
      context 'when correct' do
        it 'returns true' do
          expect(subject.valid_password?(subject.password)).to eq true
        end
      end

      context 'when incorrect' do
        it 'returns false' do
          expect(subject.valid_password?('chunkybacon')).to eq false
        end
      end
    end
  end
end
