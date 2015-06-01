-- Frost v1.1
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

local Measure,MeasureBuffer,Meter,OldHeight={},{},{},{}

function Initialize()
	
	-- Band bar height
	BarHeight=SKIN:ParseFormula(SKIN:ReplaceVariables("#Height#"))
	
	-- Spectrum width
	local Width=SKIN:ParseFormula(SKIN:ReplaceVariables("#Width#"))
	
	-- Number of bands
	local Bands=SKIN:ReplaceVariables("#Bands#")
	
	-- Band width
	InterWidth=math.ceil(Width/Bands)
	
	-- Normalized band width
	Mu=1/InterWidth
	
	-- Iteration control variables
	Sub,Index,Limit=SELF:GetOption("Sub"),SKIN:ParseFormula(SELF:GetNumberOption("Index")),SKIN:ParseFormula(SELF:GetOption("Limit"))
	
	-- Retrieve measures and meters, store in tables
	local MeasureName,MeterName,gsub=SELF:GetOption("MeasureName"),SELF:GetOption("MeterName"),string.gsub
	
	local k=1
	for i=Index,Limit do
		Meter[i],OldHeight[i],Measure[i]={},{},SKIN:GetMeasure((gsub(MeasureName,Sub,i)))
		
		for j=1,InterWidth do
		
			-- Breakpoint for the last meter because of rounding issues
			if k>Width then
				LastInterWidth=j-1
				break
			end
			
			OldHeight[i][j],Meter[i][j]=0,SKIN:GetMeter((gsub(MeterName,Sub,k)))
			k=k+1

		end
	end

end

-- http://paulbourke.net/miscellaneous/interpolation/
local function CubicInterpolate(y0,y1,y2,y3,mu)

   local mu2,a0=mu*mu,y3-y2-y0+y1
   local a1=y0-y1-a0
   return (a0*mu*mu2+a1*mu2+(y2-y0)*mu+y1)
   
end
	
function Update()
	
	local Measure=Measure
	
	-- Store measure values in buffer table
	for i=Index,Limit do
		MeasureBuffer[i]=Measure[i]:GetValue()
	end 
	
	local BarHeight,InterWidth,LastInterWidth,Mu,MeasureBuffer,Meter=BarHeight,InterWidth,LastInterWidth,Mu,MeasureBuffer,Meter
	
	-- Starting band values for calculation
	local y0,y1,y2,y3,LocalMu=MeasureBuffer[1]*BarHeight,MeasureBuffer[1]*BarHeight,MeasureBuffer[2]*BarHeight,MeasureBuffer[4]*BarHeight,0
	
	-- For each pixel in width of the first band
	for j=1,InterWidth do
		
		-- Request the interpolated point based on pixel position value
		LocalMu=LocalMu+Mu
		
		-- Check if it's a different height
		local Height=CubicInterpolate(y0,y1,y2,y3,LocalMu)
		local IntHeight=Height-Height%1
		if IntHeight~=OldHeight[1][j] then
			OldHeight[1][j]=IntHeight
			
			-- Update the bar height as the interpolated point
			Meter[1][j]:SetH(IntHeight)
			
		end		
		
	end
	
	-- For each band (Except the first and last two)
	for i=2,Limit-2 do
	
		local BarHeight,InterWidth,Mu,Measure,MeasureBuffer,Meter=BarHeight,InterWidth,Mu,Measure,MeasureBuffer,Meter[i]
		
		-- Band values for calculation
		local y0,y1,y2,y3,LocalMu=MeasureBuffer[i-1]*BarHeight,MeasureBuffer[i]*BarHeight,MeasureBuffer[i+1]*BarHeight,MeasureBuffer[i+2]*BarHeight,0
		
		-- For each pixel in width of one band
		for j=1,InterWidth do
			
			-- Request the interpolated point based on pixel position value
			LocalMu=LocalMu+Mu
			
			-- Check if it's a different height
			local Height=CubicInterpolate(y0,y1,y2,y3,LocalMu)
			local IntHeight=Height-Height%1
			if IntHeight~=OldHeight[i][j] then
				OldHeight[i][j]=IntHeight
			
				-- Update the bar height as the interpolated point
				Meter[j]:SetH(IntHeight)
				
			end
			
		end
		
	end
	
	-- Concluding band values for calculation
	y0,y1,y2,y3,LocalMu=MeasureBuffer[Limit-3]*BarHeight,MeasureBuffer[Limit-1]*BarHeight,MeasureBuffer[Limit]*BarHeight,MeasureBuffer[Limit]*BarHeight,0
	
	-- For each pixel in width of the second-to-last band
	for j=1,InterWidth do
		
		-- Request the interpolated point based on pixel position value
		LocalMu=LocalMu+Mu*0.5
		
		-- Check if it's a different height
		local Height=CubicInterpolate(y0,y1,y2,y3,LocalMu)
		local IntHeight=Height-Height%1
		if IntHeight~=OldHeight[#Meter-1][j] then
			OldHeight[#Meter-1][j]=IntHeight
			
			-- Update the bar height as the interpolated point
			Meter[#Meter-1][j]:SetH(IntHeight)
			
		end	
		
	end
	
	-- For each pixel in width of the last band
	for j=1,LastInterWidth do
		
		-- Request the interpolated point based on pixel position value
		LocalMu=LocalMu+Mu*0.5
		
		-- Check if it's a different height
		local Height=CubicInterpolate(y0,y1,y2,y3,LocalMu)
		local IntHeight=Height-Height%1
		if IntHeight~=OldHeight[#Meter][j] then
			OldHeight[#Meter][j]=IntHeight
			
			-- Update the bar height as the interpolated point
			Meter[#Meter][j]:SetH(IntHeight)
			
		end	
		
	end
	
end