require 'rails_helper'

describe 'Merchants API' do
  describe 'merchants index' do
    it 'sends a list of merchants' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants.keys.count).to eq 1
      expect(merchants.keys[0]).to eq(:data)
      expect(merchants[:data]).to be_a(Array)
      expect(merchants[:data].count).to eq 3
      expect(merchants[:data].first).to be_a(Hash)

      expect(merchants[:data].first).to have_key(:id)
      expect(merchants[:data].first[:id]).to be_an(String)

      expect(merchants[:data].first).to have_key(:type)
      expect(merchants[:data].first[:type]).to eq('merchant')

      expect(merchants[:data].first).to have_key(:attributes)
      expect(merchants[:data].first[:attributes]).to be_a(Hash)

      expect(merchants[:data].first[:attributes]).to have_key(:name)
      expect(merchants[:data].first[:attributes][:name]).to be_a(String)
    end

    describe 'edge cases' do
      it 'returns array for 1 resource' do
        create_list(:merchant, 1)

        get '/api/v1/merchants'

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to be_a(Hash)
        expect(merchants.keys.count).to eq 1
        expect(merchants.keys[0]).to eq(:data)
        expect(merchants[:data]).to be_a(Array)
        expect(merchants[:data].count).to eq 1
      end

      it 'returns array for 0 resources' do
        get '/api/v1/merchants'

        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to be_a(Hash)
        expect(merchants.keys.count).to eq 1
        expect(merchants.keys[0]).to eq(:data)
        expect(merchants[:data]).to be_a(Array)
        expect(merchants[:data].count).to eq 0
      end
    end
  end

  it 'sends a single merchant' do
    create_list(:merchant, 3)
    get "/api/v1/merchants/#{Merchant.last.id}"
    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    expect(merchant.keys.count).to eq 1
    expect(merchant.keys[0]).to eq(:data)
    expect(merchant[:data]).to be_a(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to eq('merchant')

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  describe 'sad path' do
    it 'returns error message for invalid merchant id' do
      create_list(:merchant, 3)
      get '/api/v1/merchants/h'
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      message = JSON.parse(response.body, smbolize_names: true)
      expect(message['errors']).to be_a(Array)
      expect(message['errors'][0]['status']).to eq('404')
      expect(message['errors'][0]['title']).to eq("Couldn't find Merchant with 'id'=h")
    end
  end
end
