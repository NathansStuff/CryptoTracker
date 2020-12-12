json.extract! purchase, :id, :user_id, :symbol, :cost_per, :amount, :fee, :total_cost, :description, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
