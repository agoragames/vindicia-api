require 'vindicia/model'

module Vindicia
  
  API_CLASSES = {
    "3_5" => {
        :account => [],
        :product => [:fetch_all],
        :entitlement => [:fetch_by_entitlement_id_and_account],
        :transaction => []
      }
  }

  class Entitlement
    include Savon::Model
    include Vindicia::Model

    client do
      http.headers["Pragma"] = "no-cache"
      http.auth.ssl.verify_mode = :none
    end

    vindicia_class 'Entitlement'
    api_version '3.5'
    login 'mlg_soap'
    password 'FNWV3iFIpw76gt3qpkfVCe4ZEoIx2fek'
    
    endpoint "https://soap.prodtest.sj.vindicia.com/soap.pl"
    namespace "http://soap.vindicia.com/v3_5/Entitlement"

    actions *API_CLASSES['3_5'][:entitlement]
  end

  class Product
    include Savon::Model
    include Vindicia::Model

    client do
      http.headers["Pragma"] = "no-cache"
      http.auth.ssl.verify_mode = :none
    end

    vindicia_class 'Product'
    api_version '3.5'
    login 'mlg_soap'
    password 'FNWV3iFIpw76gt3qpkfVCe4ZEoIx2fek'

    endpoint "https://soap.prodtest.sj.vindicia.com/soap.pl"
    namespace "http://soap.vindicia.com/v3_5/Product"

    actions *API_CLASSES['3_5'][:product]
  end
end

