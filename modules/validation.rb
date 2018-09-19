module Validation
  def valid?
    validation!
    true
  rescue
    false
  end
end
