class ItemsController < ApplicationController

  before_action :set_item, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(:images).order('created_at DESC')
  end

  def new
    @item = Item.new
    @category_parent = Category.where(ancestry: nil)  # データベースから、親カテゴリーのみ抽出し、配列化
    @status_array = Status.all                        # データベースから抽出し、配列化
    # @item.images.new
    @item.build_brand
  end

  # 以下、formatはjsonのみ
  def get_category_children                           # 親カテゴリーが選択された後に動くアクション
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(id: "#{params[:parent_id]}", ancestry: nil).children
  end

  def get_category_grandchildren                      # 子カテゴリーが選択された後に動くアクション
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '出品しました'
    else
      redirect_to new_item_path, notice: '必須項目を入力してください'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :text, :price, :category_id, :status_id, brand_attributes: [:id, :name], images_attributes: [:picture, :_destroy, :id])
  end

  def set_item
    @item = Item.find(params[:id])
  end

end
