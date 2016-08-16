module PropertyParams

  class Base
    # attr_reader :provider,
    #             :management_id,
    #             :type, :marcketing_name,
    #             :rental_type,
    #             :owmer_legal_name
    def get
      {
        management_id:    @management_id,
        type:             @type,
        marcketing_name:  @marcketing_name,
        rental_tpe:       @rental_type,
        owmer_legal_name: @owmer_legal_name,
      }
    end
  end

  class Ash < PropertyParams::Base
    def initialize(doc)
      @provider         = doc["provider"]
      @management_id    = doc["management_id"]
      @type             = doc["info"]["type"]
      @marcketing_name  = doc["info"]["marketing_name"]
      @rental_type      = ""
      @owmer_legal_name = doc["info"]["owmer_legal_names"]["Twitter"]
      freeze
    end
  end

  class Bozzuto < PropertyParams::Base
  end
end
