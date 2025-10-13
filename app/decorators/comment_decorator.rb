class CommentDecorator < Draper::Decorator
  delegate_all
  def comment_posting_time
    number_of_months = 12
    seconds_per_hour = 3600
    seconds_per_week = 604800
    hours_per_day = 24

    today = Time.current
    posted_time = object.published_at
    time_difference = today - posted_time
    if time_difference < 1.day
      h.content_tag(
        :div,
        (l posted_time, format: :short),
        class: "chat-footer opacity-50"
      )
    elsif time_difference < 7.day
      diff_days = (today.to_i / seconds_per_hour - posted_time.to_i / seconds_per_hour) / hours_per_day
      h.content_tag(
        :div,
        "#{diff_days}日前",
        class: "chat-footer opacity-50"
      )
    elsif time_difference < 1.month
      diff_weeks = ((today.to_f - posted_time.to_f) / seconds_per_week).ceil
      h.content_tag(
        :div,
        "#{diff_weeks}週間前",
        class: "chat-footer opacity-50"
      )
    elsif time_difference < 1.year
      diff_months = (today.year - posted_time.year) * number_of_months + today.month - posted_time.month - (today.day >= posted_time.day ? 0 : 1)
      h.content_tag(
        :div,
        "#{diff_months}か月前",
        class: "chat-footer opacity-50"
      )
    else
      diff_years = (today.year - posted_time.year) * number_of_months + today.month - posted_time.month - (today.day >= posted_time.day ? 0 : 1) / number_of_months
      h.content_tag(
        :div,
        "#{diff_years}年前",
        class: "chat-footer opacity-50"
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
