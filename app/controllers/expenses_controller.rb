class ExpensesController < ApplicationController

	before_filter :logged_in_user, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :project_active, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :is_user_assigned_to_project, only: [ :show, :edit, :update ]

	def new
		@expense = Expense.new
	end

	def create
		@expense = Expense.new(params[:expense])
		@expense.project_id = current_project.id
		@expense.user_id = current_user.id

		if @expense.save
			redirect_to current_project
		else
			render 'new'
		end
	end

	def show
#		@expense = Expense.find_by_id(params[:id])
		@member = User.find_by_id(@expense.user_id)
	end

	def edit
	end

	def update
		if @expense.update_attributes(params[:expense])
            flash[:success] = "Expense updated."
            redirect_to @expense
		else
			render 'edit'
		end
	end

	private

		def logged_in_user
    		unless loged_in?
    			store_location
    			redirect_to login_url, notice: "Please log in first."# unless loged_in?
    		end
		end

		def project_active
			unless active_project?
				redirect_to current_user, notice: "Please choose a project first before to add expenses."
			end
		end

		def is_user_assigned_to_project
			@expense = Expense.find_by_id(params[:id])
			redirect_to current_user, notice: "Please choose a project." unless @expense.project_id == current_project.id
		end

end
