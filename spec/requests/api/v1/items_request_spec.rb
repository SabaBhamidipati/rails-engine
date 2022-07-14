require 'rails_helper'

describe "Items API" do
  it "gets all items" do
    merchants = create_list(:merchant, 2)
    create_list(:item, 15, merchant: merchants.first)  
    create_list(:item, 20, merchant: merchants.last)  

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 35
    expect(items).to be_a Hash
    expect(items).to have_key(:data)
    expect(items[:data]).to be_a Array
    expect(items[:data].first).to have_key(:id)
    # binding.pry
    expect(items[:data].first).to have_key(:type)
    expect(items[:data].first).to have_key(:attributes)
    expect(items[:data].first[:attributes]).to have_key(:name)
    expect(items[:data].first[:attributes]).to have_key(:unit_price)
    expect(items[:data].first[:attributes][:unit_price]).to be_a Float
    expect(items[:data].first[:attributes]).to have_key(:description)
    expect(items[:data].first[:attributes]).to have_key(:merchant_id)
    expect(items[:data].first[:attributes][:merchant_id]).to be_a Integer
  end

  it "gets one item" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    get "/api/v1/items/#{id}"
    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item).to be_a Hash
    expect(item).to have_key(:data)
    expect(item[:data]).to have_key(:id)
    expect(item[:data]).to have_key(:type)
    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes]).to have_key(:unit_price)
     expect(item[:data][:attributes][:unit_price]).to be_a Float
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a Integer
  end
end

   