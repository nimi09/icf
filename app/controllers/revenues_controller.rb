class RevenuesController < ApplicationController

	before_filter :logged_in_user, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :project_active, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :is_user_project_admin, 		only: [ :new, :create, :edit, :update ]
	before_filter :is_user_assigned_to_project, only: [ :show, :edit, :update ]

	def new
		@revenue = Revenue.new
	end

	def create
		@revenue = Revenue.new(params[:revenue])
		@revenue.project_id = current_project.id
		@revenue.user_id    = current_user.id

		if @revenue.save
			redirect_to current_project
		else
			render 'new'
		end
	end

	def show
#		@revenue = Revenue.find_by_id(params[:id])
		@member = User.find_by_id(@revenue.user_id)
	end

	def edit
	end

	def update
		if @revenue.update_attributes(params[:revenue])
			flash[:success] = "Revenue updated."
			redirect_to @revenue
		else
			render 'edit'
		end
	end

	private

		def logged_in_user
			unless loged_in?
				store_location
				redirect_to login_url, notice: "Please log in first." unless loged_in?
			end
		end

		def project_active
			unless active_project?
				redirect_to current_user, notice: "Please choose a project first before to add a new revenue item."				
			end
		end

		def is_user_project_admin
			unless current_project.creator == current_user
				redirect_to current_user, notice: "You are not the project creator."
			end
		end

		def is_user_assigned_to_project
			@revenue = Revenue.find_by_id(params[:id])
			redirect_to current_user, notice: "Please choose a project." unless @revenue.project_id == current_project.id
		end

end
