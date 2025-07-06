module PublishedAtSettable
  extend ActiveSupport::Concern

  included do
    before_validation :set_published_at
  end

  private

  def set_published_at
    self.published_at ||= Time.current
  end
end