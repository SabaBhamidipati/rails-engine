class Api::V1::MerchantsController < ApplicationController
    def index
        render json: Merchant.all
    end

    def show  
        render json: Merchant.find(params[:id])
    end

    def create
        render json: Merchant.create
    end
end