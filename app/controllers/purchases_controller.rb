class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @purchases = Purchase.where(user_id: current_user.id)
  end

  def show
  end

  def new
    @purchase = current_user.purchases.build
  end

  def edit
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    @purchase.symbol.upcase!

    # Determine which crypto the currency belongs to
    cryptos = Crypto.where(user_id: current_user.id)
    for crypto in cryptos
      if crypto.symbol == @purchase.symbol
        @purchase.crypto_id = crypto.id
      end
    end

    # If there is no crypto it belongs to, it creates a new one
    if !@purchase.crypto_id.present?
      @crypto = current_user.cryptos.build(symbol: @purchase.symbol, amount_owned: @purchase.amount, cost_per: @purchase.total_cost)
      @crypto.save!
      @purchase.crypto_id = @crypto.id
    end

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:symbol, :cost_per, :amount, :fee, :total_cost, :description)
    end
end
