require 'rails_helper'

describe 'Merchants API' do
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
end
