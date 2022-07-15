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
    item_find = Item.find(id
    )
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
    expect(item[:data][:attributes][:name]).to eq(item_find.name)
  end

  it "sad path: gets one item" do
    fake_id = 44
    get "/api/v1/items/#{fake_id}"

    expect(response).to_not be_successful  
    expect(status).to eq 404
  end

  it "edge case: gets one item" do
    fake_id = "id"
    get "/api/v1/items/#{fake_id}"

    expect(response).to_not be_successful
    expect(status).to eq 404
  end

  it 'creates an item' do
    merchant = create(:merchant)
    item_params = {name: "Some coffee", 
                   description: "Pretty damn good",
                   unit_price: 345.84, 
                   merchant_id: merchant.id
                  }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
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
    expect(item[:data][:attributes][:name]).to eq(Item.last.name)
  end

  it 'sad path: creates an item' do
    merchant = create(:merchant)
    item_params = {name: "Some coffee", 
                   description: "Pretty damn good", 
                   merchant_id: merchant.id
                  }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    # item = JSON.parse(response.body, symbolize_names: true)  

    expect(response).to_not be_successful
    expect(status).to eq 404
  end

  it 'can delete item' do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful
  end

  it 'can update an item' do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    item_params = {name: "Some coffee" 
                  }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
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
    expect(item[:data][:attributes][:name]).to eq("Some coffee")
  end

  it 'sad path: can update item bad integer' do
    merchant = create(:merchant)
    bad_id = 20000

    item_params = {name: "Some coffee"
                  }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{bad_id}", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to_not be_successful
  end
  
  it 'edge case: can update item string id' do
    merchant = create(:merchant)
    bad_id = "please_fail"
    
    item_params = {name: "Some coffee"
    }
    
    headers = {"CONTENT_TYPE" => "application/json"}
    
    patch "/api/v1/items/#{bad_id}", headers: headers, params: JSON.generate(item: item_params)
    
    expect(response).to_not be_successful
  end
  
  it 'can get an item merchant' do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id
    
    get "/api/v1/items/#{id}/merchant"
    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    expect(merchant).to be_a Hash
    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to be_a Hash        
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a String
    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a String
  end
 
  it 'sad path: get item merchant bad integer' do
    merchant = create(:merchant)
    bad_id = 20000

    get "/api/v1/items/#{bad_id}/merchant"

    expect(response).to_not be_successful
  end
 
  it 'edge case: get item merchant string id' do
    merchant = create(:merchant)
    bad_id = "please_fail"

    get "/api/v1/items/#{bad_id}/merchant"

    expect(response).to_not be_successful
  end
end

   