require 'rails_helper'

describe 'Items API' do
  before :each do
    @merchant = create(:merchant)
  end
  describe 'items index' do
    it 'sends a list of items' do
      create_list(:item, 3, merchant_id: @merchant.id)

      get '/api/v1/items'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      expect(items.keys.count).to eq 1
      expect(items.keys[0]).to eq(:data)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq 3
      expect(items[:data].first).to be_a(Hash)

      expect(items[:data].first).to have_key(:id)
      expect(items[:data].first[:id]).to be_an(String)

      expect(items[:data].first).to have_key(:type)
      expect(items[:data].first[:type]).to be_a(String)
      expect(items[:data].first[:type]).to eq('item')

      expect(items[:data].first).to have_key(:attributes)
      expect(items[:data].first[:attributes]).to be_a(Hash)

      expect(items[:data].first[:attributes]).to have_key(:name)
      expect(items[:data].first[:attributes][:name]).to be_a(String)

      expect(items[:data].first[:attributes]).to have_key(:description)
      expect(items[:data].first[:attributes][:description]).to be_a(String)

      expect(items[:data].first[:attributes]).to have_key(:unit_price)
      expect(items[:data].first[:attributes][:unit_price]).to be_a(Float)
    end

    describe 'edge cases' do
      it 'returns array for 1 resource' do
        create_list(:item, 1, merchant_id: @merchant.id)

        get '/api/v1/items'

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to be_a(Hash)
        expect(items.keys.count).to eq 1
        expect(items.keys[0]).to eq(:data)
        expect(items[:data]).to be_a(Array)
        expect(items[:data].count).to eq 1
      end

      it 'returns array for 0 resources' do
        get '/api/v1/items'

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to be_a(Hash)
        expect(items.keys.count).to eq 1
        expect(items.keys[0]).to eq(:data)
        expect(items[:data]).to be_a(Array)
        expect(items[:data].count).to eq 0
      end
    end
  end

  describe 'items show' do
    it 'sends a single item' do
      create_list(:item, 3, merchant_id: @merchant.id)

      get "/api/v1/items/#{Item.last.id}"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to be_a(Hash)
      expect(item.keys.count).to eq 1
      expect(item.keys[0]).to eq(:data)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_an(String)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to eq('item')

      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to be_a(Hash)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    end
    describe 'sad path' do
      it 'returns error message for invalid item id' do
        create_list(:item, 3, merchant_id: @merchant.id)

        get '/api/v1/items/h'
        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        message = JSON.parse(response.body, smbolize_names: true)
        expect(message['errors']).to be_a(Array)
        expect(message['errors'][0]['status']).to eq('404')
        expect(message['errors'][0]['title']).to eq("Couldn't find Item with 'id'=h")
      end
    end
  end

  describe 'items create' do
    it 'can create a new item' do
      item_params = {
        name: 'value1',
        description: 'value2',
        unit_price: 100.99,
        merchant_id: @merchant.id
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  it 'can update an existing item' do
    id = create(:item, merchant_id: @merchant.id).id
    previous_name = Item.last.name
    item_params = { name: 'Shoes' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Shoes')
  end

  it 'can destroy an existing item' do
    item = create(:item, merchant_id: @merchant.id)

    expect { delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
