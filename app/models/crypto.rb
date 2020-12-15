class Crypto < ApplicationRecord
    has_many :purchases
    has_many :users
end
