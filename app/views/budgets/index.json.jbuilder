json.array!(@budgets) do |budget|
  json.extract! budget, :id, :acctno, :description, :annualbudget, :yeartodate, :prioryeartodate, :percentbudgetused
  json.url budget_url(budget, format: :json)
end
