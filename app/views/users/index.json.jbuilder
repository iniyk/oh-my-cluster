json.array!(@users) do |user|
  json.extract! user, :id, :name, :passwd_md5, :role, :group, :info
  json.url user_url(user, format: :json)
end
