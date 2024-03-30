# frozen_string_literal: true

module Web::Tasks
  class ListsController < BaseController
    before_action :set_task_list, only: [:edit, :update, :destroy]

    before_action only: [:edit, :update, :destroy] do
      if @task_list.inbox?
        head :unprocessable_entity
      end
    end

    def index
      render("web/tasks/lists/index", locals: {task_lists: current_user.task_lists})
    end

    def new
      render("web/tasks/lists/new", locals: {task_list: TaskList.new})
    end

    def create
      task_list = Current.account.task_lists.build(task_list_params)

      if task_list.save
        redirect_to web_tasks_lists_path, notice: "Task list created"
      else
        render("web/tasks/lists/new", locals: {task: task})
      end
    end

    def edit
      render("web/tasks/lists/edit", locals: {task_list: @task_list})
    end

    def update
      if @task_list.update(task_list_params)

        redirect_to web_tasks_lists_path, notice: "Task list updated"
      else
        render("web/tasks/lists/edit", locals: {task_list: @task_list})
      end
    end

    def destroy
      @task_list.destroy!

      self.current_task_list_id = nil

      redirect_to web_tasks_lists_path, notice: "Task list deleted"
    end

    private

    def set_task_list
      @task_list = current_user.task_lists.find(params[:id])
    end

    def task_list_params
      params.require(:task_list).permit(:name)
    end
  end
end
