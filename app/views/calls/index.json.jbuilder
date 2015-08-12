json.array!(@calls) do |call|
  json.extract! call, :id, :to, :from
  json.url call_url(call, format: :json)
end
