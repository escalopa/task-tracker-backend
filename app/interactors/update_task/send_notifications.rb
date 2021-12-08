class UpdateTask
  class SendNotifications
      include Interactor

      delegate :task, :current_user, to: :context

      def call
          create_avtivity
      end

      private 

        def create_avtivity
            RegisterActivityJob.perform_now(current_user.id, "Task Updated", task.id, "Task")
        end
    end
end