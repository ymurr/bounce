class ChangeTable < ActiveRecord::Migration
  def change
    rename_column :budgets, :acctno, :account
    rename_column :budgets, :annualbudget, :annual_budget
    rename_column :budgets, :yeartodate, :year_to_date
    rename_column :budgets, :prioryeartodate, :prior_year_to_date
    rename_column :budgets, :percentbudgetused, :percent_budget_used
  end
end
