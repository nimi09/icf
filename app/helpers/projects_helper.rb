module ProjectsHelper

	def set_current_project(project)
		cookies.permanent[:cpi] = project.id # cpi => Current Project Id
		self.current_project = project
	end

	def active_project?
		!current_project.nil?
	end

	def current_project=(project)
		@current_project = project
	end

	def current_project
		cpi = cookies[:cpi]
		@current_project ||= Project.find_by_id(cpi)
	end

	def current_project?(project)
		project == current_project
	end

	def destroy_current_project
		cookies.delete(:cpi) # cpi => Current Project Id		
		self.current_project = nil unless self.current_project == nil
	end

#######################################

	def calculate_user_income(expenses, rentals, workinghours, revenues, user)
		# User Values for Expenses, Rentals, Workinghours
		ue = current_project.expenses.where(user_id: user.id).sum(:amount)
		ur = current_project.rentals.where(user_id: user.id).sum(:amount)
		uw = current_project.workinghours.where(user_id: user.id).sum(:hours) + (current_project.workinghours.where(user_id: user.id).sum(:minutes).to_f / 60 )

		# MemberRevenue
		mr = 0

		# UserPercentageExpenses
		unless expenses == 0
#			uep = (ue * 100) / expenses
			uep = ue / expenses
		else
			uep = 0
		end

		#UserPercentageRentals
		unless rentals == 0
#			urp = (ur * 100) / rentals
			urp = ur / rentals
		else
			urp = 0
		end

		#UserPercentageWorkinghours
		unless workinghours == 0
#			uwp = (uw * 100) / workinghours
			uwp = uw / workinghours
		else
			uwp = 0
		end

		# Budgets
		be = expenses #BudgetExpenses
		if be > revenues
			be = revenues
		end

		br = rentals
		if br > revenues - expenses
			br = revenues - expenses

			if br < 0
				br = 0
			end
		end
		
		bwh = revenues - be - br
		if bwh < 0
			bwh = 0
		end

		mr = (be * uep) + (br * urp) + (bwh * uwp)
		mr

	end

#######################################


end
