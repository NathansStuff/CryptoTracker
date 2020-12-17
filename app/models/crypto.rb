class Crypto < ApplicationRecord
    has_many :purchases, dependent: :destroy
    has_many :users
end
