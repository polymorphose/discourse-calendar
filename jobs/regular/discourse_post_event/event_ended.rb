# frozen_string_literal: true

module Jobs
  class DiscoursePostEventEventEnded < ::Jobs::Base
    sidekiq_options retry: false

    def execute(args)
      raise Discourse::InvalidParameters.new(:event_id) if args[:event_id].blank?
      event = DiscoursePostEvent::Event.find(args[:event_id])
      MessageBus.publish("/topic/#{event.post.topic_id}", refresh_stream: true)
      DiscourseEvent.trigger(:discourse_post_event_event_ended, event)
    end
  end
end
