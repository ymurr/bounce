class ProductImport
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
      if imported_products.map(&:valid?).all?
        imported_products.each(&:save!)
        true
      else
        imported_products.each_with_index do |product, index|
          product.errors.full_messages.each do |message|
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



  def imported_products
      @imported_products ||= load_imported_products
  end

  def load_imported_products
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    products_array = Array.new
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]


      parameters = ActionController::Parameters.new(row.to_hash)
      product = Product.find_by_id(parameters[:'id']) || Product.new

      product.attributes = {name: parameters[:'name'], released_on: parameters[:'released_on'], price: parameters[:'price']}

      products_array << product
    end

    products_array
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
