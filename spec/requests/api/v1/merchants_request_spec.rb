require 'rails_helper'

describe "Merchants API" do
    it "sends a list of merchants" do
        create_list(:merchant, 3)

        get '/api/v1/merchants'
       
        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq 3
        expect(response).to be_successful
        expect(merchants).to be_a Hash
        expect(merchants).to have_key(:data)
        expect(merchants[:data]).to be_a Array        
        expect(merchants[:data].first).to have_key(:id)
        expect(merchants[:data].first[:id]).to be_a String
        expect(merchants[:data].first).to have_key(:type)
        expect(merchants[:data].first).to have_key(:attributes)
        expect(merchants[:data].first[:attributes]).to have_key(:name)
        expect(merchants[:data].first[:attributes][:name]).to be_a String
    end

    it "can find merchant by id" do
        id = create(:merchant).id
 
        get "/api/v1/merchants/#{id}"
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
    
    it 'sad path: can find merchant by id' do
        fake_id = 44
        get '/api/v1/merchants/(fake_id)'
      
        expect(status).to eq(404)
    end
  
    it "can get all items for a given merchant id" do
        merchant = create(:merchant)
        create_list(:item, 15, merchant: merchant)

        get "/api/v1/merchants/#{merchant.id}/items"

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(items).to be_a Hash
        expect(items).to have_key(:data)
        # binding.pry
        expect(items[:data].first).to be_a Hash
        expect(items[:data].first).to have_key(:id)
        expect(items[:data].first).to have_key(:type)
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)
    end

    it 'sad path: returns all items from one merchant' do
        merchant = 12
        get "/api/v1/merchants/(merchant)/items"

        expect(response).to_not be_successful
        expect(status).to eq(404)
    end
end