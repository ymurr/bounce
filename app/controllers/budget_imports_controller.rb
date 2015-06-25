class BudgetImportsController < ApplicationController
  def new
    @budget_import = BudgetImport.new
  end

  def create
    @budget_import = BudgetImport.new(params[:budget_import])
    if @budget_import.save
      redirect_to budgets_url, notice: "Imported budgets successfully."
    else
      render :new
    end
  end
end
