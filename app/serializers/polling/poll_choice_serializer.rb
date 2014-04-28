module Polling
  class PollChoiceSerializer < Canvas::APISerializer
    attributes :id, :text, :is_correct

    has_one :poll, embed: :id

    def_delegators :object, :course, :poll
    def_delegators :@controller, :api_v1_course_poll_url

    def filter(keys)
      if is_teacher?
        student_keys + teacher_keys
      else
        student_keys
      end
    end

    def poll_url
      api_v1_course_poll_url(course, poll)
    end

    private
    def is_teacher?
      poll.grants_right?(current_user, session, :update)
    end

    def teacher_keys
      [:is_correct]
    end

    def student_keys
      [:id, :text]
    end
  end
end
