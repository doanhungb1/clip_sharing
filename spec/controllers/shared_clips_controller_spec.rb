require "rails_helper"

describe SharedClipsController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) do
    { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
  end
  let(:auth_header) { Devise::JWT::TestHelpers.auth_headers(headers, user) }

  describe 'POST shared_clips', type: :request do
    let(:path) { '/shared_clips' }
    let(:params) do
      { "clip_url": 'youtube.com' }
    end
    let(:shared_clip) { create(:shared_clip, user: user, title: "something", author_name: "Author name")}

    context 'with authenticated token' do
      before do
        class_double = double()
        allow(ClipSharing::Container).to receive(:[]).with('save_clip_from_url').and_return(class_double)
        allow(class_double).
          to receive(:call).
          with(user: user, clip_url: 'youtube.com').
          and_return(service_double)
      end

      context 'service returns success' do
        let(:service_double) { double(success?: true, value!: shared_clip) }

        it 'returns 201' do
          post path, params: params.to_json, headers: auth_header
          expect(response.status).to eq(201)
          expect(JSON.parse(response.body)["author_name"]).to eq("Author name")
        end
      end

      context 'service returns success' do
        let(:service_double) { double(success?: false, failure: [:failed_to_saved_clip, 'Missing something']) }

        it 'returns 201' do
          post path, params: params.to_json, headers: auth_header
          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['error']['message']).to eq("Missing something")
        end
      end
    end
  end
end