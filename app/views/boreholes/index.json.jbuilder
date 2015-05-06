json.array!(@boreholes) do |borehole|
  json.extract! borehole, :id
  json.url borehole_url(borehole, format: :json)
end
