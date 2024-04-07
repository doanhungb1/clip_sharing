require 'rails_helper'

RSpec.describe SaveClipFromUrl do
  let!(:user) { create(:user) }
  let(:clip_url) { 'https://www.youtube.com/watch?v=FrLcMrl97bE'}

  subject do
    described_class.new.call(
      user: user,
      clip_url: clip_url
    )
  end

  context 'with wrong format URL' do
    let(:clip_url) { 'abc'}

    it 'returns failure' do
      expect(subject).to be_failure
      expect(subject.failure[0]).to eq(:invalid_params)
    end
  end

  context 'with invalid URL' do
    before do
      allow(RestClient).
        to receive(:get).
        with(any_args).
        and_raise(RestClient::BadRequest)
    end

    it 'returns failure' do
      expect(subject).to be_failure
      expect(subject.failure[0]).to eq(:invalid_params)
    end
  end

  context 'with valid url' do
    let(:clip_info) do
      {
        items: [
          {
            id: 'FrLcMrl97bE',
            snippet: {
              title: 'Something',
              description: 'description'
            }

          }
        ]
      }.to_json
    end

    before do
      allow(RestClient).
        to receive(:get).
        with(any_args).
        and_return(double(body: clip_info))
    end

    it 'processes saving clip' do
      expect(ActionCable.server).to receive(:broadcast).with('notifications', any_args)
      expect(subject).to be_success
      expect(subject.value!.class).to eq(SharedClip)
      expect(subject.value!.title).to eq('Something')
    end

    context 'when failed to save to db' do
      let(:clip_info) do
        {
        items: [
          {
            id: 'FrLcMrl97bE',
            snippet: {
              title: nil,
              description: 'description'
            }

          }
        ]
      }.to_json
      end

      it 'returns failure' do
        expect(subject).to be_failure
        expect(subject.failure[0]).to eq(:failed_to_saved_clip)
        expect(subject.failure[1]).to eq("Title can't be blank")
      end
    end
  end
end