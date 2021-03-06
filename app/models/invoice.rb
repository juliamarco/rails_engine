class Invoice < ApplicationRecord
  enum status: ['pending', 'shipped']

  belongs_to :customer
  belongs_to :merchant

  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  validates_presence_of :status
  scope :shipped, -> {where(status: 'shipped')}

end
