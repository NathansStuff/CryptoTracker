class HomeController < ApplicationController
  def index

    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
    headers = {
        'X-CMC_PRO_API_KEY': '571099ec-2545-49b6-84dc-432d3a2d3c3b',
    }
    
    response = HTTParty.get(url, headers: headers)
    coins = JSON.parse(response.body)
    @coins = coins['data']
    @my_coins = ['BTC','XRP','XLM']

  end
  
  def about
  end
  
  def lookup
  end
end

# curl -H "X-CMC_PRO_API_KEY: 571099ec-2545-49b6-84dc-432d3a2d3c3b" -H "Accept: application/json" -d "start=1&limit=5000&convert=USD" -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest