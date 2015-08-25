function Update()
  local width = SKIN:ParseFormula(SKIN:GetVariable("Width"))
  local height = SKIN:ParseFormula(SKIN:GetVariable("Height"))
  local horizontal = SKIN:ParseFormula(SKIN:GetVariable("Horizontal"))
  
  for i = 1, width do
	SKIN:Bang("!SetOption", "MeterRotator" .. i, "Group", "Rotators")
    SKIN:Bang("!UpdateMeter", "MeterRotator" .. i)
	
	if horizontal == 0 then SKIN:Bang("!SetOption", "MeterRotator" .. i, "X", i-1)
	else SKIN:Bang("!SetOption", "MeterRotator" .. i, "Y", i-1) end
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