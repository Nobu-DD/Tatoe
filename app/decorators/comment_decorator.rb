class CommentDecorator < Draper::Decorator
  delegate_all

  def comment_posting_time
    number_of_months = 12
    seconds_per_hour = 3600
    hours_per_day = 24

    today = Time.current
    posted_time = object.published_at
    time_difference = today - posted_time
    if time_difference < 1.day
      h.content_tag(
        :div,
        l posted_time, format: :short,
        class: "chat-footer opacity-50"
      )
    elsif time_difference < 7.day
        diff_days = (today.to_i / SECONDS_PER_HOUR - posted_time.to_i / SECONDS_PER_HOUR) / HOURS_PER_DAY
        h.content_tag(
          :div,
          "#{diff_days}日前",
          class: "chat-footer opacity-50"
        )
      elsif time_difference < 1.year
        diff_months = (today.year - posted_time.year) * NUMBER_OF_MONTHS + today.month - posted_time.month - (today.day >= posted_time.day ? 0 : 1)
        h.content_tag(
          :div,
          "#{diff_months}か月前",
          class: "chat-footer opacity-50"
        )
      else
        diff_years = (today.year - posted_time.year) * NUMBER_OF_MONTHS + today.month - posted_time.month - (today.day >= posted_time.day ? 0 : 1) / NUMBER_OF_MONTHS
        h.content_tag(
          :div,
          "#{diff_years}年前",
          class: "chat-footer opacity-50"
        )
      end
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
