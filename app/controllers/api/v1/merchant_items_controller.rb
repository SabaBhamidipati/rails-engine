class Api::V1::MerchantItemsController < ApplicationController
    def index   
        Merchant.exists?(params[:merchant_id])
        merchant = Merchant.find(params[:merchant_id])
        render json: MerchantItemSerializer.new(merchant.items)
    end
end
