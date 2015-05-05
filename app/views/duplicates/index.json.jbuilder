json.array!(@duplicates) do |duplicate|
  json.extract! duplicate, :id
  json.url duplicate_url(duplicate, format: :json)
end
