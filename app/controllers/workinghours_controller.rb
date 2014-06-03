class WorkinghoursController < ApplicationController

	before_filter :logged_in_user, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :project_active, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :is_user_assigned_to_project, only: [ :show, :edit, :update ]

	def new
		@workinghour = Workinghour.new
	end

	def create
		@workinghour = Workinghour.new(params[:workinghour])
		@workinghour.project_id = current_project.id
		@workinghour.user_id    = current_user.id

		if @workinghour.save
			redirect_to current_project
		else
			render 'new'
		end
	end

	def show
#		@workinghour = Workinghour.find_by_id(params[:id])
		@member = User.find_by_id(@workinghour.user_id)
	end

	def edit
	end

	def update
		if @workinghour.update_attributes(params[:workinghour])
            flash[:success] = "Working hour updated."
            redirect_to @workinghour
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
				redirect_to current_user, notice: "Please choose a project first before to add a new rental item."				
			end
		end

		def is_user_assigned_to_project
			@workinghour = Workinghour.find_by_id(params[:id])
			redirect_to current_user, notice: "Please choose a project." unless @workinghour.project_id == current_project.id
		end

end