json.array!(@duplicate_groups) do |duplicate_group|
  json.extract! duplicate_group, :id
  json.url duplicate_group_url(duplicate_group, format: :json)
end
