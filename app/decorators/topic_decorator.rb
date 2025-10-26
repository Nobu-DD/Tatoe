class TopicDecorator < Draper::Decorator
  delegate_all

  def topic_json_data
    {
      id: object.id,
      title: object.title,
      description: object.description,
      hints: object.hints.map(&:body)
    }.to_json
  end
end
