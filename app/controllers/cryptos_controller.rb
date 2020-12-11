class CryptosController < ApplicationController
  before_action :set_crypto, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /cryptos
  # GET /cryptos.json
  def index
    @cryptos = []
    cryptos = Crypto.includes(:user).each do |crypto|
      if crypto.user_id == current_user.id
        @cryptos << crypto
      end
    end
  end

  # GET /cryptos/1
  # GET /cryptos/1.json
  def show
  end

  # GET /cryptos/new
  def new
    @crypto = current_user.cryptos.build
  end

  # GET /cryptos/1/edit
  def edit
    authorize! :owner, @crypto
  end

  # POST /cryptos
  # POST /cryptos.json
  def create
    @crypto = current_user.cryptos.build(crypto_params)
    # @crypto.user_id == current_user.id

    respond_to do |format|
      if @crypto.save
        format.html { redirect_to @crypto, notice: 'Crypto was successfully created.' }
        format.json { render :show, status: :created, location: @crypto }
      else
        format.html { render :new }
        format.json { render json: @crypto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cryptos/1
  # PATCH/PUT /cryptos/1.json
  def update
    authorize! :owner, @crypto
    respond_to do |format|
      if @crypto.update(crypto_params)
        format.html { redirect_to @crypto, notice: 'Crypto was successfully updated.' }
        format.json { render :show, status: :ok, location: @crypto }
      else
        format.html { render :edit }
        format.json { render json: @crypto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cryptos/1
  # DELETE /cryptos/1.json
  def destroy
    authorize! :owner, @crypto
    @crypto.destroy
    respond_to do |format|
      format.html { redirect_to cryptos_url, notice: 'Crypto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crypto
      @crypto = Crypto.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def crypto_params
      params.require(:crypto).permit(:symbol, :cost_per, :amount_owned)
    end
end
