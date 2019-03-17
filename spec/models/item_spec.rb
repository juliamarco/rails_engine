require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :invoices }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
    @merchant_4 = create(:merchant)

    @customer_1 = create(:customer)
    @customer_2 = create(:customer)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_2)
    @item_4 = create(:item, merchant: @merchant_3)
    @item_5 = create(:item, merchant: @merchant_4)

    @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, merchant_id: @merchant_1.id, created_at: "2019-03-10 07:13:13 UTC", customer_id: @customer_2.id)
    @invoice_3 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer_2.id, created_at: "2019-03-13 07:13:13 UTC")
    @invoice_4 = create(:invoice, merchant_id: @merchant_2.id, created_at: "2019-03-13 07:13:13 UTC")
    @invoice_5 = create(:invoice, merchant_id: @merchant_3.id, created_at: "2019-03-13 23:13:13 UTC")
    @invoice_6 = create(:invoice, merchant_id: @merchant_4.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 2)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 7, unit_price: 2)
    @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_4.id, quantity: 20, unit_price: 5)
    @invoice_item_4 = create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_5.id, quantity: 10, unit_price: 8)
    @invoice_item_5 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_6.id, quantity: 2, unit_price: 2)
    @invoice_item_6 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_3.id, quantity: 7, unit_price: 2)

    @transaction_1 = create(:transaction, invoice_id: @invoice_1.id)
    @transaction_2 = create(:transaction, invoice_id: @invoice_2.id)
    @transaction_3 = create(:transaction, invoice_id: @invoice_3.id)
    @transaction_4 = create(:transaction, invoice_id: @invoice_4.id)
    @transaction_5 = create(:transaction, invoice_id: @invoice_5.id)
    @transaction_6 = create(:transaction, invoice_id: @invoice_6.id)
  end

  describe 'class methods' do

    it '.top_by_revenue' do
      expect(Item.top_by_revenue).to eq([@item_3, @item_4, @item_1])
    end

    it '.top_by_number_sold' do
      expect(Item.top_by_number_sold).to eq([@item_3, @item_1, @item_4])
    end

    it '.best_day' do
      expect(Item.best_day(@item_1.id)).to eq("2019-03-13")
    end



  end


end
