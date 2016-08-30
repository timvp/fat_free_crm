class FusionInvoiceClient < ActiveRecord::Base
	
	establish_connection "website_#{Rails.env}"
	self.table_name = :clients
	
	def create_client(id, name, address, phone, mobile, email, btw, clienttype)
	
	  length = 32
	  url_key = (36**(length-1) + rand(36**length - 36**(length-1))).to_s(36)
	  
	  address = address.nil? ? "" : address
	  name = name.nil? ? "" : name 
	  phone = phone.nil? ? "" : phone
	  mobile = mobile.nil? ? "" : mobile
	  email = email.nil? ? "" : email
	  btw = btw.nil? ? "" : btw
	
	
		sql = "INSERT INTO `clients` ( `name`, `address`, `phone`, `mobile`, `email`, `url_key`, `currency_code`, `created_at`, `updated_at`) VALUES ('"+name+"', '"+address+"','"+phone+"', '"+mobile+"', '"+email+"', '"+url_key+"', 'EUR', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP() );"
    self.connection.execute(sql)
    
    sql = "INSERT INTO clients_custom (client_id, column_1, column_2, created_at, updated_at, column_3) VALUES (last_insert_id(),'"+btw+"','"+clienttype+"', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), '"+id.to_s+"' );"
    self.connection.execute(sql)
	
	end
	
	def update_client(id, name, address, phone, mobile, email, btw, clienttype)
	
  	address = address.nil? ? "" : address
	  name = name.nil? ? "" : name 
	  phone = phone.nil? ? "" : phone
	  mobile = mobile.nil? ? "" : mobile
	  email = email.nil? ? "" : email
	  btw = btw.nil? ? "" : btw
	
	
	
	 sql = "UPDATE clients SET name = '"+name+"', address = '"+address+"', phone = '"+phone+"', mobile = '"+mobile+"', email = '"+email+"', updated_at = CURRENT_TIMESTAMP() WHERE id = (select client_id from clients_custom where column_3 = '"+id.to_s+"');"
	 self.connection.execute(sql)
	 
	 sql = "UPDATE clients_custom SET column_1 = '"+btw+"' WHERE column_3 = '"+id.to_s+"';"
	 self.connection.execute(sql)
 end	
	
	
	def delete_client
	 sql = "UPDATE clients SET active = 0 WHERE client_id = (select id from clients_custom where column_3 = "+id.to_s+"');"
	 self.connection.execute(sql)
  end	
	 

end
