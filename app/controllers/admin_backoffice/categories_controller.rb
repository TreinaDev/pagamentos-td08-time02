class AdminBackoffice::CategoriesController < AdminBackofficeController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name, :discount))

    if @category.save!
      redirect_to admin_backoffice_categories_path, notice: I18n.t(:success)
    end
  end
end