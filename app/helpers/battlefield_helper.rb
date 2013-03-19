module BattlefieldHelper
  def radar_block(value)
    return "<span class='round success label'>X<span>" if value == 1
    return "<span class='round secondary label'>&nbsp;<span>" if value == -1
  end

  def battlefield_block(value, hit)
    return "<span class='round alert label'>#{value}<span>" if hit == 1
    return "<span class='round secondary label'>&nbsp;<span>" if hit == -1
    return "<span class='round secondary label'>#{value}<span>" if value != 0
  end
end