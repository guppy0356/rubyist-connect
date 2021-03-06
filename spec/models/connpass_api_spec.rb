require 'rails_helper'

describe ConnpassApi do
  describe '::fetch_event_details' do
    let(:expected) do
      {
          "status" => :ok,
          "event" => {
              "title" => "もくもく会＃８",
              "participant_profiles" => expected_profiles
          },
      }
    end

    let(:expected_profiles) do
      [
          {
              "name" => "akira-noguchi",
              "twitter" => "nodic",
              "github" => nil
          },
          {
              "name" => "Djokov07",
              "twitter" => "Djokov07",
              "github" => nil
          },
          {
              "name" => "shojik",
              "twitter" => "kobayashi_shoji",
              "github" => nil
          },
          {
              "name" => "TakehiroIkeda",
              "twitter" => "cyross4vocaloid",
              "github" => "cyross"
          },
          {
              "name" => "masanari_takegawa",
              "twitter" => nil,
              "github" => nil
          },
          {
              "name" => "sakaguchi_yusuke",
              "twitter" => nil,
              "github" => "GuCode"
          },
      ]
    end

    example 'as hash' do
      event_url = 'https://connpass.com/event/39406/'
      VCR.use_cassette 'connpass_events/39406', match_requests_on: [:uri] do
        result = ConnpassApi.new.fetch_event_details(event_url)
        expect(result).to match expected
      end
    end

    context 'when there are no participants' do
      it 'is success' do
        event_url = 'https://67ws.connpass.com/event/141508/'
        VCR.use_cassette 'connpass_events/141508', match_requests_on: [:uri] do
          expect {
            result = ConnpassApi.new.fetch_event_details(event_url)
            expect(result["event"]["participant_profiles"].size).to eq(0)
          }.to_not raise_error
        end
      end
    end

    context 'when "(退会ユーザー)" is include' do
      it 'is success' do
        event_url = 'https://hikalab-kansai.connpass.com/event/41353/'
        VCR.use_cassette 'connpass_events/41353', match_requests_on: [:uri] do
          expect {
            result = ConnpassApi.new.fetch_event_details(event_url)
            expect(result["event"]["participant_profiles"].size).to eq(19)
          }.to_not raise_error
        end
      end
    end
  end
end