json.array!(@nodes) do |node|
  json.extract! node, :id, :name, :address, :user, :id_rsa, :id_rsa_pub, :info
  json.url node_url(node, format: :json)
end
