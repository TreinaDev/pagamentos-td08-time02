class AdminBackoffice::RegisteredAdminsController < AdminBackofficeController
  def approval
    @pending_admins = Admin.search_pending_admins
  end

  def approve
    admin = Admin.find(params[:id])
    admin.inactive? ? admin.pending! : admin.active!
  end

  def refuse
    admin = Admin.find(params[:id])
    admin.refused!
  end
end
