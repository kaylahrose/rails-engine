class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :error_response

  def error_response(error)
    render json: ErrorSerializer.error_json(error), status: 404
  end

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params))
  end

  def update
    render json: ItemSerializer.new(Item.update(item_params))
  end

  def destroy
    render json: ItemSerializer.new(Item.destroy(params[:id]))
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end