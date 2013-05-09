class Array
  def self.wrap(obj)
    obj.is_a?(Array) ? obj : (obj.nil? ? [] : [obj])
  end
end
