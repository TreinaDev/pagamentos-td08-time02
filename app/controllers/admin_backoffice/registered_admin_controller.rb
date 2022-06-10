class AdminBackoffice::RegisteredAdminController < AdminBackofficeController
  def approval
    @pending_admins = Admin.search_pending_admins
  end

  def approve
    admin = Admin.find(params[:id])
    admin.update(status: 3)
  end

  def refuse
  end
end
