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

  context 'with invalid URL' do
    before do
      allow(RestClient).
        to receive(:get).
        with("https://www.youtube.com/oembed?format=json&url=https://www.youtube.com/watch?v=FrLcMrl97bE").
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
        "title": "Something",
        "author_name": "Hung dep trai"
    }.to_json
    end

    before do
      allow(RestClient).
        to receive(:get).
        with("https://www.youtube.com/oembed?format=json&url=https://www.youtube.com/watch?v=FrLcMrl97bE").
        and_return(double(body: clip_info))
    end

    it 'processes saving clip' do
      expect(subject).to be_success
      expect(subject.value!.class).to eq(SharedClip)
      expect(subject.value!.title).to eq('Something')
    end

    context 'when failed to save to db' do
      let(:clip_info) do
        {
          "title": nil,
          "author_name": "Hung dep trai"
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