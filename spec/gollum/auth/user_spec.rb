require 'spec_helper'

module Gollum::Auth
  describe User do
    let(:params)  { { user: 'Homer', password: 'Marge' } }
    let(:subject) { User.new(params) }

    describe '#user' do
      it 'must be present' do
        subject.user = nil
        expect(subject).to be_invalid
      end
    end

    describe '#password' do
      it 'must be present' do
        subject.password = nil
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
          subject.user = nil
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
  end
end
