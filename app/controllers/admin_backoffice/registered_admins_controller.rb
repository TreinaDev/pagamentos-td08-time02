class AdminBackoffice::RegisteredAdminsController < AdminBackofficeController
  before_action :set_admin, only: %i[approve refuse]
  
  def approval
    @pending_admins = Admin.search_pending_admins
  end

  def approve
    if @admin.inactive?
      @admin.pending!
      @admin.update(admin_id: current_admin.id)
    else
      @admin.active!
    end

    redirect_to admin_backoffice_pending_admins_path
  end

  def refuse
    @admin.refused!
    redirect_to admin_backoffice_pending_admins_path
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end
end
