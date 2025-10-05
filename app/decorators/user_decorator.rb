class UserDecorator < Draper::Decorator
  delegate_all

  def avatar_display?
    if object.avatar.present?
      h.image_tag(
        object.avatar.url,
        alt: "プロフィール画像",
        class: "aspect-square h-full w-full"
        )
    else
      h.content_tag(
        :span,
        object[:name][0],
        class: "flex h-full w-full items-center justify-center bg-[#E0F2FE] text-[#0369A1] text-2xl"
      )
    end
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
