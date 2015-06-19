json.array!(@products) do |product|
  json.extract! product, :id, :name, :released_on, :price
  json.url product_url(product, format: :json)
end
