class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string :acctno
      t.string :description
      t.decimal :annualbudget
      t.decimal :yeartodate
      t.decimal :prioryeartodate
      t.decimal :percentbudgetused

      t.timestamps null: false
    end
  end
end
