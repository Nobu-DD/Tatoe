class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[privacy_policy terms_of_service usage_guide]

  def privacy_policy; end

  def terms_of_service; end

  def usage_guide; end
end
