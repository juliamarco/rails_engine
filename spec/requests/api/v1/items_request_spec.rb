require 'rails_helper'

describe "Items API" do

  before :each do
    @merchant = create(:merchant, id: 1, name: "Koepp, Waelchi and Donnelly", created_at: "2012-03-27 14:54:05 UTC", updated_at: "2012-03-27 14:54:05 UTC")

    @item_1 = create(:item, id: 1, name: "Item Qui Esse", description: "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.", unit_price: 75107, merchant_id: 1, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
    @item_2 = create(:item, id: 2, name: "Item Autem Minima", description: "Cumque consequuntur ad. Fuga tenetur illo molestias enim aut iste. Provident quo hic aut. Aut quidem voluptates dolores. Dolorem quae ab alias tempora.", unit_price: 67076, merchant_id: 1, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
    @item_3 = create(:item, id: 3, name: "Item Ea Voluptatum,", description: "Sunt officia eum qui molestiae. Nesciunt quidem cupiditate reiciendis est commodi non. Atque eveniet sed. Illum excepturi praesentium reiciendis voluptatibus eveniet odit perspiciatis. Odio optio nisi rerum nihil ut.", unit_price: 32301, merchant_id: 1, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
    @item_4 = create(:item, id: 4, name: "Item Nemo Facere", description: "Sunt eum id eius magni consequuntur delectus veritatis. Quisquam laborum illo ut ab. Ducimus in est id voluptas autem.", unit_price: 4291, merchant_id: 1, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
  end

  it "sends a list of items" do

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)["data"]

    expect(items.count).to eq(4)
  end

  it "can get one item by its id" do

    get "/api/v1/items/#{@item_1.id}"
    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(item["id"].to_i).to eq(@item_1.id)
  end

  it "can get one item using finders" do
    id = @item_1.id
    name = @item_1.name
    description = @item_1.description
    unit_price = "274.09"
    merchant_id = @item_1.merchant_id
    created_at = @item_1.created_at
    updated_at = @item_1.updated_at

    get "/api/v1/items/find?id=#{id}"
    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(item["id"].to_i).to eq(id)

    get "/api/v1/items/find?name=#{name}"

    expect(response).to be_successful
    expect(item["attributes"]["name"]).to eq(name)

    get "/api/v1/items/find?name=#{description}"

    expect(response).to be_successful
    expect(item["attributes"]["description"]).to eq(description)

    get "/api/v1/items/find?unit_price=#{unit_price}"
    # binding.pry
    expect(response).to be_successful
    # expect(item["attributes"]["unit_price"]).to eq((unit_price/ 100.00).to_s)

#     def test_it_can_find_first_instance_by_unit_price
#   item = load_data("/api/v1/items/find?unit_price=#{item_find['unit_price']}")["data"]
#
#   item_find.each do |attribute|
#     assert_equal item_find[attribute], item["attributes"][attribute]
#   end
# end

    get "/api/v1/items/find?name=#{merchant_id}"

    expect(response).to be_successful
    expect(item["attributes"]["merchant_id"]).to eq(merchant_id)

    get "/api/v1/items/find?created_at=#{created_at}"

    expect(response).to be_successful
    id = item["attributes"]["id"].to_i
    date = Item.find(id).created_at
    expect(date).to eq("2012-03-27T14:53:59.000Z")

    get "/api/v1/items/find?updated_at=#{updated_at}"

    expect(response).to be_successful

    date = Item.find(id).updated_at

    expect(date).to eq("2012-03-27T14:53:59.000Z")
  end

  it "can get all items matches using finders" do

    get "/api/v1/items/find_all?name=#{@item_2.name}"

    items = JSON.parse(response.body)["data"]

    expect(response).to be_successful

    expect(items.first["attributes"]["name"]).to eq(@item_2.name)
    expect(items.count).to eq(1)

    get "/api/v1/items/find_all?created_at=#{@item_1.created_at}"

    items = JSON.parse(response.body)["data"]

    expect(response).to be_successful

    id = items.first["attributes"]["id"].to_i
    date = Item.find(id).created_at

    expect(date).to eq("2012-03-27T14:53:59.000Z")
  end

  it "can return a random resource" do

    items_names = [@item_1.name, @item_2.name, @item_3.name]

    get "/api/v1/items/random"

    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(items_names).to include(item["attributes"]["name"])
  end

  it "can return invoice items associated with an item" do

    invoice_item_1 = create(:invoice_item, item_id: @item_1.id)
    invoice_item_2 = create(:invoice_item, item_id: @item_1.id)
    invoice_item_3 = create(:invoice_item, item_id: @item_1.id)

    invoice_items = [invoice_item_1, invoice_item_2, invoice_item_3]

    invoice_items_ids = invoice_items.map { |ii| ii.id}

    get "/api/v1/items/#{@item_1.id}/invoice_items"
    invoice_items = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_items.count).to eq(3)

    i_i_ids = invoice_items.map { |ii| ii["attributes"]["id"] }

    expect(invoice_items_ids).to eq(i_i_ids)
  end

  it "can return the associated merchant for an item" do

    get "/api/v1/items/#{@item_1.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)["data"]

    expect(merchant["attributes"]["id"]).to eq(@item_1.merchant_id)
  end



end
