class StaticPagesController < ApplicationController

	before_filter :is_user_admin, only: [ :display_row_count ]

	def home
	end

	def contact
	end

	def faq
	end

	def display_row_count
		@rowcount = User.count + Project.count + AssignedProject.count + Expense.count + Rental.count + Workinghour.count + Revenue.count + Feedback.count
	end

	private

		def is_user_admin
		  redirect_to root_url unless current_user.admin?
		end

end
