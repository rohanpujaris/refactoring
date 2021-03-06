module Spreadsheet
  class Import
    attr_reader :mapping, :reader

    def initialize(mapping, reader)
      @mapping = mapping
      @reader = reader
    end

    def import(model)
      reader.each_row(mapping.values) do |row|
        attributes = process(unprocessed_row(row))
        model.create(attributes)
      end
    end

    def process_row(unprocessed_row)
      # Do some processing on row
    end

    # will return data in format {column_name1: 'column_value', column_name2: value}
    def unprocessed_row(row)
      {}.tap do |attributes|
        mapping.keys.each_with_index do |column_name, index|
          attributes[column_name] = row[index]
        end
      end
    end
  end
end

reader = Spreadsheet::SimpleReader.new('tax.csv', start_row: 1, end_row: 120)
Spreadsheet::Import({city: 0, tax_rate: 1}, reader).import(Tax)