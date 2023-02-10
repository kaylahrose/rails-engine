require 'rails_helper'

describe 'Items API' do
  before :each do
    @merchant = create(:merchant)
  end

  it 'sends a list of items' do
    create_list(:item, 3, merchant_id: @merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
    end
  end
  it 'sends a single item' do
    create_list(:item, 3, merchant_id: @merchant.id)

    get "/api/v1/items/#{Item.last.id}"

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(Integer)

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to be_a(Integer)
  end
end
