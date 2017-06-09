json.extract! record, :id, :date, :who, :description, :split, :price, :comment, :created_at, :updated_at
json.url record_url(record, format: :json)
