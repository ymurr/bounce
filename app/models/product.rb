class Product < ActiveRecord::Base

    validates_presence_of :price

    def self.to_csv(options = {})
      wanted_column_names = ['id', 'name', 'released_on', 'price']
      CSV.generate(options) do |csv|
        csv << wanted_column_names
        all.each do |product|
          csv << product.attributes.values_at(*wanted_column_names)
        end
      end
    end

   # def self.import(file)
   #   spreadsheet = open_spreadsheet(file)
   #   header = spreadsheet.row(1)

   #   (2..spreadsheet.last_row).each do |i|
   #     row = Hash[[header, spreadsheet.row(i)].transpose]
   #
   #
   #        parameters = ActionController::Parameters.new(row.to_hash)
   #        product = find_by_id(parameters[:'Id']) || new

   #      product.update(:name => parameters[:'Name'],
   #                     :released_on => parameters[:'Release Date'],
   #                   :price => parameters[:'Price'])
   #

   #   end
   # end

    #def self.open_spreadsheet(file)
   #   case File.extname(file.original_filename)
   #     when ".csv" then Roo::CSV.new(file.path)
   #     when ".xls" then Roo::Excel.new(file.path)
   #     when ".xlsx" then Roo::Excelx.new(file.path)
   #     else raise "File type is not valid for import: #{file.original_filename}"
   #   end
   # end

end
