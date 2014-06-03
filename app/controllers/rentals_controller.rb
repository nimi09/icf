class RentalsController < ApplicationController

	before_filter :logged_in_user, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :project_active, 				only: [ :new, :create, :show, :edit, :update ]
	before_filter :is_user_assigned_to_project, only: [ :show, :edit, :update ]

	def new
		@rental = Rental.new
	end

	def create
		@rental = Rental.new(params[:rental])
		@rental.project_id = current_project.id
		@rental.user_id    = current_user.id

		if @rental.last_date && @rental.last_date && @rental.amount_per_day.to_i && @rental.amount_per_day && @rental.amount_per_day > 0
			@rental.amount = ((@rental.last_date.to_date - @rental.first_date.to_date).to_i + 1) * @rental.amount_per_day
		end

		if @rental.save
			redirect_to current_project
		else
			render 'new'
		end
	end

	def show
		@rental = Rental.find_by_id(params[:id])
		@member = User.find_by_id(@rental.user_id)
	end

	def edit
	end

	def update
		if @rental.update_attributes(params[:rental])
			@rental.update_attribute( :amount, (((@rental.last_date.to_date - @rental.first_date.to_date).to_i + 1) * @rental.amount_per_day) )
            flash[:success] = "Rental updated."
            redirect_to @rental
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
			@rental = Rental.find_by_id(params[:id])
			redirect_to current_user, notice: "Please choose a project." unless @rental.project_id == current_project.id
		end

end
