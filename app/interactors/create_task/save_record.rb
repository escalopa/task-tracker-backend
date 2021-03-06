# frozen_string_literal: true

class CreateTask
  class SaveRecord
    include Interactor

    delegate :task_params, :task, to: :context

    def call
      context.task = create_task
      context.fail!(error: 'Invalid task data') unless task.save
    end

    private

    def create_task
      Task.new(task_params)
    end
  end
end
