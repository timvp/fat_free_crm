class EmailComposition  #< ActiveRecord::Base

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :subject, :body, :cc, :bcc, :contactids, :save_as_mail, :attachment
    
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  
  private
  
   
end
