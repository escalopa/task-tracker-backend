# frozen_string_literal: true

module Mutations
  class CreateTask < BaseMutation
    argument :input, Types::Inputs::CreateTaskInput, required: true

    type Types::TaskType

    def resolve(input:)
      result = ::CreateTask.call(
        task_params: input.to_h,
        current_user: current_user
      )
      result.task if result.success?
    end
  end
end
