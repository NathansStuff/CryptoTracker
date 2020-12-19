class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_file, only: [:index, :show, :update]

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
    # @crypto = ''
    # Determine which crypto the currency belongs to
    cryptos = Crypto.where(user_id: current_user.id)
    for crypto in cryptos
      if crypto.symbol == @purchase.symbol
        @purchase.crypto_id = crypto.id
      end
    end

    # If there is no crypto it belongs to, it creates a new one
    if !@purchase.crypto_id.present?
      @crypto = current_user.cryptos.build(symbol: @purchase.symbol, amount_owned: 0, cost_per: 0)
      @crypto.save!
      @purchase.crypto_id = @crypto.id
    end

    respond_to do |format|
      if @purchase.save
        update_crypto(@purchase)

        # @crypto = Crypto.where(user_id: current_user.id, id: @purchase.crypto_id)
        # p '****************'
        # p @crypto
        # p '//////////'
        # p @crypto.amount_owned

        # Update the crypto variables
        # @crypto.amount_owned += @purchase.amount
        # @crypto.cost_per += ((@purchase.total_cost) / (@purchase.amount))


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

    def update_crypto(purchase)
      cryptos = Crypto.where(user_id: current_user.id)
      for crypto in cryptos
        if crypto.symbol == @purchase.symbol
          @crypto = crypto
          @crypto_total_cost = @crypto.cost_per * @crypto.amount_owned
        end
      end

      if purchase.description == 'Buy'
        @crypto_total_cost += @purchase.total_cost
        @crypto.amount_owned += purchase.amount
        @crypto_new_total_cost = @crypto_total_cost / @crypto.amount_owned
        @crypto.cost_per = @crypto_new_total_cost
        @crypto.save!
      else
        @crypto_total_cost -= @purchase.total_cost
        @crypto.amount_owned -= purchase.amount
        @crypto_new_total_cost = @crypto_total_cost / @crypto.amount_owned
        @crypto.cost_per = @crypto_new_total_cost
        @crypto.save!




        # @crypto.amount_owned -= purchase.amount
      

        # The math doesn't work properly for selling
        # @crypto.cost_per -= ((purchase.total_cost)/(purchase.amount))
      end
      @crypto.save!
    end

    def set_file
      @file = File.join(Rails.root, "app", "assets", "images")
    end
end


# How to update it???!!