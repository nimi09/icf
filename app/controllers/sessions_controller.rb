class SessionsController < ApplicationController
	before_filter :no_logged_in_user, 	only: [:new]

	def new
	end

	def create
		user = User.find_by_username(params[:session][:username])
		if user && user.authenticate(params[:session][:password])
			log_in user
			redirect_back_or user
		else
			flash.now[:error] = "Invalid username/password combination"
			render 'new'
		end
	end

	def destroy
		log_out
		redirect_to root_url
	end

	private

		def no_logged_in_user
			redirect_to current_user, notice: "You are allready logged in!" if loged_in?			
		end

end
