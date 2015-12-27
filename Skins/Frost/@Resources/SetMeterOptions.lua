function Update()
  local width, height = SKIN:ParseFormula(SKIN:GetVariable("Width")), SKIN:ParseFormula(SKIN:GetVariable("Height"))
  local horizontal = SKIN:ParseFormula(SKIN:GetVariable("Horizontal"))
  local meterName = {}
  
  for i = 1 + 1, width + 1 do
    meterName[i] = "MeterRotator" .. i-1
	if SKIN:GetMeter(meterName[i]) == nil then return 0 end
    SKIN:Bang("!SetOption", meterName[i], "Group", "Rotators")
    SKIN:Bang("!UpdateMeter", meterName[i])
  end
  
  for i = 1 + 1, width + 1 do
	if horizontal == 0 then SKIN:Bang("!SetOption", meterName[i], "X", i-2)
	else SKIN:Bang("!SetOption", meterName[i], "Y", i-2) end
  end
  
  if horizontal == 0 then
    SKIN:Bang("!SetOptionGroup", "Rotators", "GradientAngle", 90)
    SKIN:Bang("!SetOptionGroup", "Rotators", "W", 1)
  else SKIN:Bang("!SetOptionGroup", "Rotators", "H", 1) end
  
  SKIN:Bang("!SetOptionGroup", "Rotators", "SolidColor", "#Color#,255")
  SKIN:Bang("!SetOptionGroup", "Rotators", "SolidColor2", "#Color#,0")
  
  SKIN:Bang("!SetOptionGroup", "Rotators", "TransformationMatrix", SKIN:GetMeasure("Matrix"):GetStringValue())
  SKIN:Bang("!UpdateMeterGroup", "Rotators")
  SKIN:Bang("!SetOptionGroup", "Rotators", "TransformationMatrix", "")
  
  SKIN:Bang("!UpdateMeterGroup","Rotators")
end