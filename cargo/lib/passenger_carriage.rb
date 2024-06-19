require_relative 'carriage'
require_relative 'validation'

class PassengerCarriage < Carriage
    include Validation
  
    COMPANY_NAME_FORMAT = /\A[a-zA-Z\s&'-]{1,30}\z/.freeze
  
    validate :company_name, :presence
    validate :company_name, :format, with: COMPANY_NAME_FORMAT
  
    def initialize(company_name)
      super()
      @company_name = company_name
      validate!
    end
  end
