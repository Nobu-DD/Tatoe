class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[privacy_policy]

  def privacy_policy; end
end
