json.array!(@roles) do |role|
  json.extract! role, :id, :name, :mask, :privileges
  json.url role_url(role, format: :json)
end
