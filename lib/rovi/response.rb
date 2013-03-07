module Rovi
  class Response

    def initialize(data = {})
      @data = data
    end

    def success?
      @data['status']
    end

    def method_missing(m)
      key = m.to_s
      if @hash != nil and @hash.has_key?(key)
        v = @hash[key]
        v = JsonResponse.new(v) if v.is_a?(Hash)
        return v
      else
        super
      end
    end

  end
end
