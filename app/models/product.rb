class Product < ActiveRecord::Base


    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end

    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)

      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]


        #=====start of Working version !!! ================================
        parameters = ActionController::Parameters.new(row.to_hash)
        product = find_by_id(parameters[:'Id']) || new

        #if product.exist?
          product.update(:name => parameters[:'Name'],
                        :released_on => parameters[:'Release Date'],
                        :price => parameters[:'Price'])


        #else
        #  Product.where(:id => parameters[:'Id'],
        #              :name => parameters[:'Name'],
        #              :released_on => parameters[:'Release Date'],
        #              :price => parameters[:'Price']).first_or_create
       # end


        #=====end of Working version !!! ======================================




       #=======start of not yet working version ================================
       #product.attributes = row.to_hash.slice(Product.attribute_names)
        #product = find_by_id(parameters[:'Id']) || new
        #product.update(parameters.permit(:id, :name, :released_on, :price))
        #product.save!
        #=======end of not yet working version ================================


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
