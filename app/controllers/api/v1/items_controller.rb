class Api::V1::ItemsController < ApplicationController

    def index
        render json: ItemSerializer.new(Item.all)
    end

    def show
        render json: ItemSerializer.new(Item.find(params[:id]))
    end

    def create
        item = Item.new(item_params)
        if item.save
            render json: ItemSerializer.new(item), status: 201
        else 
            record_not_found 
        end
    end

    def destroy
        item = Item.find(params[:id])
        item.destroy
        render json: "", status: 204
    end

    def update
        item = Item.find(params[:id])
        if item.update(item_params)            
            # item.update(item_params)
            render json: ItemSerializer.new(item)
        else
            record_not_found
        end
    end

    private
    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end