class Api::V1::MerchantsController < ApplicationController
    def index
        render json: MerchantSerializer.new(Merchant.all)
    end

    def show  
            merchant = Merchant.find(params[:id])
            render json: MerchantSerializer.new(merchant)
    end

    def find
        merchant = Merchant.find_first_partial(params[:name])
        if merchant.valid?
            render json: MerchantSerializer.new(merchant)
        else 
           render json: MerchantSerializer.new(merchant)
        end
    end
end