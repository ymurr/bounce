class BudgetImport
  extend ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    begin
      if imported_budgets.map(&:valid?).all?
        imported_budgets.each(&:save!)
        true
      else
        imported_budgets.each_with_index do |budget, index|
          budget.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}"
          end
        end
        false
      end
    rescue => e
      errors.add :base, e.message
      false
    end

  end



  def imported_budgets
      @imported_budgets ||= load_imported_budgets
  end

  def load_imported_budgets
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    budgets_array = Array.new
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]


      parameters = ActionController::Parameters.new(row.to_hash)
      budget = Budget.find_by_id(parameters[:'id']) || Budget.new

      budget.attributes = {account: parameters[:'account'],
                    description: parameters[:'description'],
                    annual_budget: parameters[:'annual_budget'],
                    year_to_date: parameters[:'year_to_date'],
                    prior_year_to_date: parameters[:'prior_year_to_date'],
                    percent_budget_used: parameters[:'percent_budget_used']}

      budgets_array << budget
    end

    budgets_array
  end



  def open_spreadsheet
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "File type is not valid for import: #{file.original_filename}"
    end
  end


end
