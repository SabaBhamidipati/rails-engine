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

        render json: MerchantSerializer.new(merchant)
        # merchant_find = Merchant.find(params[:name]).downcase
        # if merchant_find.exists?
        #     render json: MerchantSerializer.new(merchant_find).first
        # else
        #     record_not_found
        
    end
end