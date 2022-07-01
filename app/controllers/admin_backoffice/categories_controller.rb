class AdminBackoffice::CategoriesController < AdminBackofficeController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
    @bonus = BonusConversion.order(:percentage)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_backoffice_categories_path, notice: I18n.t(:create_success)
    else
      flash.now[:alert] = I18n.t(:create_fail)
      @bonus = BonusConversion.order(:percentage)
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
    @bonus = BonusConversion.order(:percentage)
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to admin_backoffice_categories_path, notice: I18n.t(:update_success)
    else
      flash.now[:notice] = I18n.t(:update_fail)
      @bonus = BonusConversion.order(:percentage)
      render 'edit'
    end
  end

  private

  def category_params
    category_params = params.require(:category).permit(:name, :discount, :bonus_conversion_id)
  end
end