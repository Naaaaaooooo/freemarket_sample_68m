class PurchaseController < ApplicationController
  before_action :set_card, only: [:index, :pay]
  before_action :set_item, only: [:index, :pay]
  before_action :set_address, only: [:index]
  require 'payjp'

  def index
    if @card.blank?
      redirect_to controller: "card", action: "new"
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(@card.card_id)
    end
  end

  def pay
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      customer: @card.customer_id,
      currency: 'jpy',
    )

    @item.update(buyer_id: current_user.id)
    if @item.save
      flash[:notice] = "購入が完了しました"
      redirect_to root_path
    else
      flash[:notice] = "購入ができませんでした"
      redirect_to action: "index"
    end
  end


  private
  def set_card
    @card = Card.find_by(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_address
    @address = Address.find_by(user_id: current_user.id)
  end

end
