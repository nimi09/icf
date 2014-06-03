class ProjectsController < ApplicationController

	before_filter :logged_in_user,              only: [:new, :create, :show, :edit, :update, :status, :addcrewmember, :assign_invited_user, :all_crew_members,	:member_expenses, :member_rentals, :member_workinghours, :member_revenues ]
    before_filter :is_user_assigned_to_project, only: [:show, :edit, :update, :addcrewmember, :status, :assign_invited_user, :all_crew_members,					:member_expenses, :member_rentals, :member_workinghours, :member_revenues ]
    before_filter :is_user_project_creator,     only: [:edit, :update,:addcrewmember, :assign_invited_user ]

    def new
    	@project = Project.new
        @project.assigned_projects.build(user_id: current_user)
    end

    def create
        @project = Project.new(params[:project])

        if @project.save
            @project.assigned_projects.create(user_id: current_user)
            redirect_to current_user
        else
            render 'new'
        end
    end

    def show
#        @project = Project.find(params[:id])   ## >> is allready done in the function is_user_assigned_to_project
    end

    def edit
#        @project = Project.find(params[:id])   ## >> is allready done in the function is_user_assigned_to_project
        @ap = current_project.assigned_projects.where(user_id: current_user.id).first
    end

    def update
#        @project = Project.find(params[:id])   ## >> is allready done in the function is_user_assigned_to_project
        if current_project.update_attributes(project_params)
            # Update Position!!! =)
            a = AssignedProject.where(user_id: current_user.id, project_id: current_project.id).first
            a.attributes = { position: params[:project][:assigned_project][:position] }
            a.save

            flash[:success] = "Project updated."
            redirect_to current_project
        else
            @ap = current_project.assigned_projects.where(user_id: current_user.id).first
            render 'edit'
        end
    end


###################################################################
# Custom Functions                                                #
###################################################################

    def status
        @members = current_project.users.all

        @expenses = current_project.expenses.all

        @all_expenses = current_project.expenses.sum(:amount)
        @all_rentals  = current_project.rentals.sum(:amount)

        @all_hours = current_project.workinghours.sum(:hours)
        @all_minutes = current_project.workinghours.sum(:minutes)

        while @all_minutes >= 60 do
        	@all_hours += 1
        	@all_minutes -= 60
   		end

        @all_revenues = current_project.revenues.sum(:amount)
    end

    def addcrewmember
        @user = User.new
    end

    def assign_invited_user
        @user = User.find_by_email(params[:user][:email].downcase)
#        @project = Project.find(params[:id]) # wurde schon in def is_user_assigned_to_project geldaen
        if @user
            p = @user.projects.find_by_id(params[:id]) 
            if p
                # @user is allready member => do nothing and rerender invite
                redirect_to addcrewmember_project_path, notice: "#{@user.username.upcase} is allready a Crew Member!"
            else
                # @user is not a member add him and create assigne_project relation
                ap = @user.assigned_projects.build(project: current_project, position: params[:user][:assigned_projects][:position])
                if ap.save
                    redirect_to project_path(current_project), notice: "Added #{@user.username.upcase} to \"" + current_project.name + "\"!" ## => Added USERNAME as Crew Member to the project!
                else
                    @user = User.new
                    flash.now[:error] = "Position can't be blank!"
                    render 'addcrewmember'#, notice: "user was not found"
                end
            end
        else
            @user = User.new
            flash.now[:error] = "No user found with that email! Please, inform your crew member to sign up with IN CREW FU!"
            render 'addcrewmember'#, notice: "user was not found"
#            display debug view
#            redirect_to current_user, notice: "User was NOT found! :-("
        end
            
#        redirect_to(root_url) unless current_user?(@user)
    end

    def all_crew_members
        @members = current_project.users.all

        @total_expenses = current_project.expenses.sum(:amount)
        @total_rentals  = current_project.rentals.sum(:amount)
        @total_workinghours = current_project.workinghours.sum(:hours) + (current_project.workinghours.sum(:minutes).to_f / 60)
        @total_revenues = current_project.revenues.sum(:amount)
    end

    def crew_member
        @member = current_project.users.find(params[:uid])
    end

    def member_expenses
       @member = current_project.users.find(params[:uid])
       @expenses = current_project.expenses.where(user_id: @member.id).order('date DESC')
#  	   @fixes = Fix.paginate(page: params[:page], :per_page => 30).order("name ASC")    	
    end

    def member_rentals
       @member = current_project.users.find(params[:uid])
       @rentals = current_project.rentals.where(user_id: @member.id).order('last_date DESC')
    end

    def member_workinghours
       @member = current_project.users.find(params[:uid])
       @workinghours = current_project.workinghours.where(user_id: @member.id).order('date DESC')
    end

    def member_revenues
    	@member = current_project.users.find(params[:uid])
    	@revenues = current_project.revenues.where(user_id: @member.id).order('date DESC')
    end

    private

        def project_params
            params.require(:project).permit(:name, :currency, :position)
        end

    	def logged_in_user
    		unless loged_in?
    			store_location
    			redirect_to login_url, notice: "Please log in first." unless loged_in?
    		end
    	end

        def is_user_assigned_to_project
#           is current_project equal to params
#               => Procede
#           else if user is assigned to project
#               set_current_project and proceed
#           else not valid project

            if active_project?
#                project = current_user.projects.find_by_id(params[:id])
#                if current_project?(project)
                unless current_project.id == params[:id]
                    #check whether user is subcribed to project or not
                    project = current_user.projects.find_by_id(params[:id])
                    if project
                        set_current_project(project)
                    else
                        redirect_to current_user, notice: "Yor are not a member of that project."
                    end
                end
            else
                #check whether user is subcribed to project or not
                project = current_user.projects.find_by_id(params[:id])
                if project
                    set_current_project(project)
                else
                    redirect_to current_user, notice: "Yor are not a member of that project."
                end
            end

# => OLD CODE:
#            @project = current_user.projects.find_by_id(params[:id])
#            unless @project
#                redirect_to current_user
#            end
        end

        def is_user_project_creator
            unless current_project.creator_id == current_user.id
                redirect_to project_path, notice: "You are not the creator and thus not admin of this project!"
            end
        end

# => 7.3.2 Strong parameters // if required for def create
#        def project_params
#            params.require(:user_or_project_here?).permit(:name, :currentproject, :currency, :controlled)
#        end

end
