class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :key, :description, :raw_text
end
