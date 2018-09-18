module Validation
  def valid?
    validation!
  rescue
    false
  end
end
