class Pickup < ApplicationRecord
  validates :start_at, presence: true
  validate :start_must_be_before_end, if: -> { end_at.present? }
  belongs_to :topic

  scope :active, -> { where("start_at <= ? AND (end_at IS NULL OR end_at >= ?)", Time.current, Time.current) }

  private

  def start_must_be_before_end
    if start_at > end_at
      errors.add(start_at, "は終了日時より前に設定してください")
    end
  end
end
