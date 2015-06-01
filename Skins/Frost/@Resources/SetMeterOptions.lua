function Update()
	
	-- Parse these values only once to be easily read on every update cycle
	local Width=SKIN:ParseFormula(SKIN:ReplaceVariables("#Width#"))
	local Height=SKIN:ParseFormula(SKIN:ReplaceVariables("#Height#"))
	local Color=SKIN:ReplaceVariables("#Color#")
	
	local Meter={}
	local gsub,Sub,MeterName=string.gsub,SELF:GetOption("Sub"),SELF:GetOption("MeterName")
	for i=1,Width do
		Meter[i]=(gsub(MeterName,Sub,i))
		SKIN:Bang("!SetOption",Meter[i],"Group","Bars")
		SKIN:Bang("!UpdateMeter",Meter[i])
		
		SKIN:Bang("!SetOption",Meter[i],"X",i-1)
	end
	
	SKIN:Bang("!SetOptionGroup","Bars","W",1)
	
	SKIN:Bang("!SetOptionGroup","Bars","TransformationMatrix","#Scale#;0;0;(#Flip# = 0 ? -#Scale# : #Scale#);0;(#Flip# = 0 ? (#Height#*#Scale#) : 0)")
	SKIN:Bang("!UpdateMeterGroup","Bars")
	
	-- Unset the matrix after the meters have been transformed
	SKIN:Bang("!SetOptionGroup","Bars","TransformationMatrix","")
	
	SKIN:Bang("!SetOptionGroup","Bars","BarColor","255,0,0,0")
	SKIN:Bang("!SetOptionGroup","Bars","GradientAngle",90)
	
	-- If it's an RGB color
	if Color:find(",") then
	
		SKIN:Bang("!SetOptionGroup","Bars","SolidColor","#Color#,255")
		SKIN:Bang("!SetOptionGroup","Bars","SolidColor2","#Color#,0")
		
	-- If it's a HEX color
	else
		
		SKIN:Bang("!SetOptionGroup","Bars","SolidColor","#Color#FF")
		SKIN:Bang("!SetOptionGroup","Bars","SolidColor2","#Color#00")
		
	end
	
	SKIN:Bang("!SetOptionGroup","Bars","UpdateDivider",1)
	SKIN:Bang("!UpdateMeterGroup","Bars")
	
end