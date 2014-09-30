class SetListSerializer < ActiveModel::Serializer
  attributes :id, :title
  embed :ids, :include => true

  has_many :songs
end
