class UsersController < ApplicationController
	before_filter :no_logged_in_user, 	only: [:new]
	before_filter :loged_in_user, 		only: [:show, :edit, :update]
	before_filter :correct_user,  		only: [:show, :edit, :update]
	before_filter :admin_user,    		only: [:index, :destroy]

	def index
        @users = User.paginate(page: params[:page], :per_page => 30).order("LOWER(username)")
	end

	def show
#		@user = User.find(params[:id]) ## not needed because correct_user calls it
	    @projects = current_user.projects
	end	

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			log_in @user
			flash[:success] = "Welcome to Independent Crew Funding"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
#		@user = User.find(params[:id])   ## not needed because correct_user calls it
	end

	def update
#		@user = User.find(params[:id])  ## not needed because correct_user calls it
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:sucess] = "User deleted."
		redirect_to users_url
	end


	private

		def user_params
			params.require(:user).permit(:username, :email, :password, :password_confirmation)
		end

		# Before filters

		def no_logged_in_user
			redirect_to current_user, notice: "You allready have an account!" if loged_in?
		end
		
		def loged_in_user
			unless loged_in?
				store_location
				redirect_to login_url, notice: "Please log in." unless loged_in?
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def admin_user
			if current_user
				redirect_to(root_path) unless current_user.admin?
			else
				redirect_to(root_path)
			end
		end
end
