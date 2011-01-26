module Vindicia
  
  API_CLASSES = {
    "3_5" => {
        :account => [],
        :entitlement => [:fetch_by_entitlement_id_and_account],
        :transaction => []
      }
  }

  class Entitlement
    include Savon::Model

    client do
      http.headers["Pragma"] = "no-cache"
    end

    endpoint "https://soap.prodtest.sj.vindicia.com/soap.pl"
    namespace "http://soap.vindicia.com/v3_5/Entitlement"

    actions *API_CLASSES['3_5'][:entitlement]
  end

end