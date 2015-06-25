class Budget < ActiveRecord::Base

  validates_presence_of :account, :description, :percent_budget_used


  def self.to_csv(options = {})

    wanted_column_names = ['id','account', 'description', 'annual_budget', 'year_to_date', 'prior_year_to_date', 'percent_budget_used']
    CSV.generate(options) do |csv|
      csv << wanted_column_names
      all.each do |budget|
        csv << budget.attributes.values_at(*wanted_column_names)
      end
    end
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]


      parameters = ActionController::Parameters.new(row.to_hash)
      budget = find_by_id(parameters[:'id']) || new

      budget.update(:account => parameters[:'account'],
                     :description => parameters[:'description'],
                     :annual_budget => parameters[:'annual_budget'],
                     :year_to_date => parameters[:'year_to_date'],
                     :prior_year_to_date => parameters[:'prior_year_to_date'],
                     :percent_budget_used => parameters[:'percent_budget_used'])



      #budget.update(:acctno => parameters[:'Acct No'],
      #               :description => parameters[:'Description'],
      #               :annualbudget => parameters[:'Annual Budget '],
      #               :yeartodate => parameters[:'Year To Date'],
      #               :prioryeartodate => parameters[:'Prior Year To Date'],
      #               :percentbudgetused => parameters[:'Percent Budget Used']
      #)

    end
  end



  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "File type is not valid for import: #{file.original_filename}"
    end
  end

end
