class AnswerDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def reactions_count(id)
    case id
    when 1
      object.empathy_count
    when 2
      object.consent_count
    when 3
      object.smile_count
    end
  end
end
