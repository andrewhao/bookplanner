class BookBag < ActiveRecord::Base
  belongs_to :classroom
  validates :global_id, numericality: true, presence: true
  validates :global_id, uniqueness: { scope: :classroom_id }

  scope :active, -> { where(active: true) }
end
