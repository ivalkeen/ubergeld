class Money
  module Inspectable
    def inspect
      to_s
    end

    def to_s
      format("%g", round(2))
    end
  end
end
