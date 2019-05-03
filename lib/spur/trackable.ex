defprotocol Spur.Trackable do
  def actor(_trackable)
  def object(_trackable)
  def target(_trackable)
  def audience(_trackable)
end
