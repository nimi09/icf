class FeedbacksController < ApplicationController

	before_filter :logged_in_user

	def new
		@feedback = Feedback.new()
		catch_all_feedbacks
#		response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
		expires_now
	end

	def create
		@feedback = Feedback.new(params[:feedback])

		if @feedback.save
			flash[:success] = "Thank you for your feedback."	
			@feedback = Feedback.new()

		catch_all_feedbacks
			render 'new'
		else
		catch_all_feedbacks
			render 'new'
		end
	end

	def destroy
		Feedback.find(params[:id]).destroy
		flash[:success] = "Feedback deleted."
		redirect_to new_feedback_url
	end

	def implemented
		redirect_to new_feedback_url
   	end

	def voteup
		f = Feedback.find_by_id(params[:id])
		f.votes += 1
		f.save

		@feedback = Feedback.new()
		catch_all_feedbacks
		render 'new'
	end

	def votedown
		f = Feedback.find_by_id(params[:id])
		f.votes -= 1
		f.save

		@feedback = Feedback.new()
		catch_all_feedbacks
		render 'new'
	end

	def newestfirst
		cookies.permanent[:fbov] = 0
		fetch_feedback_order
		redirect_to "/feedbacks/new"
	end

	def byvotes
		cookies.permanent[:fbov] = 1
		fetch_feedback_order
		redirect_to "/feedbacks/new"
	end

	private

		def catch_all_feedbacks
			fetch_feedback_order
			if @o == "1"
				@feedbacks = Feedback.order("votes DESC").all
			else
				@feedbacks = Feedback.order("created_at DESC").all
			end
		end

		def logged_in_user
			redirect_to root_url unless loged_in?				
		end

		def fetch_feedback_order
			@o = cookies[:fbov] #:fbo => Feed Back Order Votes
			if @o == nil
				@o = "0"
				cookies.permanent[:fbov] = @o
			end
		end

end
