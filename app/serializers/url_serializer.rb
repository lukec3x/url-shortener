class UrlSerializer
  include JSONAPI::Serializer
  attributes :id, :original_url, :short_url, :visits
end
