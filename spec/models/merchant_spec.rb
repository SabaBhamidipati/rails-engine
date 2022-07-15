require 'rails_helper'

RSpec.describe Merchant, type: :model do
 describe 'class methods' do
    it '.find_all_by_name' do
        @sams_furniture = create(:merchant, name: "Sam's Furniture")
        @sabas_furniture = create(:merchant, name: "Saba's Furniture")
# binding.pry
        expect(Merchant.find_first_partial("Sa")).to eq(@sabas_furniture)
    end
 end
end
