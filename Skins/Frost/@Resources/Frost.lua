-- Frost v1.0
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

local Measure,MeasureBuffer,Meter={},{},{}

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
	
	-- Retrieve measures and meter names, store in tables
	local MeasureName,MeterName,gsub=SELF:GetOption("MeasureName"),SELF:GetOption("MeterName"),string.gsub
	
	local k=1
	for i=Index,Limit do
		Meter[i],Measure[i]={},SKIN:GetMeasure((gsub(MeasureName,Sub,i)))
		
		for j=Index,InterWidth do
			Meter[i][j]=(gsub(MeterName,Sub,k))
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
	
	-- Store measure values in buffer table
	for i=Index,Limit do
		MeasureBuffer[i]=Measure[i]:GetValue()
	end 
	
	-- Starting band values for calculation
	local y0,y1,y2,y3,LocalMu=MeasureBuffer[1]*BarHeight,MeasureBuffer[1]*BarHeight,MeasureBuffer[2]*BarHeight,MeasureBuffer[4]*BarHeight,0
	
	-- For each pixel in width of the first band
	for j=1,InterWidth do
		
		-- Request the interpolated point based on pixel position value
		LocalMu=LocalMu+Mu
		
		-- Update the background meter height as the interpolated point
		SKIN:Bang("!SetOption",Meter[1][j],"H",CubicInterpolate(y0,y1,y2,y3,LocalMu))
		
	end
	
	-- For each band (Except the first and last two)
	for i=2,Limit-2 do
	
		local Meter=Meter[i]
		
		-- Band values for calculation
		local y0,y1,y2,y3,LocalMu=MeasureBuffer[i-1]*BarHeight,MeasureBuffer[i]*BarHeight,MeasureBuffer[i+1]*BarHeight,MeasureBuffer[i+2]*BarHeight,0
		
		-- For each pixel in width of one band
		for j=1,InterWidth do
			
			-- Request the interpolated point based on pixel position value
			LocalMu=LocalMu+Mu
			
			-- Update the background meter height as the interpolated point
			SKIN:Bang("!SetOption",Meter[j],"H",CubicInterpolate(y0,y1,y2,y3,LocalMu))
			
		end
		
	end
	
	-- Concluding band values for calculation
	y0,y1,y2,y3,LocalMu=MeasureBuffer[Limit-3]*BarHeight,MeasureBuffer[Limit-1]*BarHeight,MeasureBuffer[Limit-1]*BarHeight,MeasureBuffer[Limit]*BarHeight,0
	
	-- For each pixel in width of the second-to-last band
	for j=1,InterWidth do
		
		-- Request the interpolated point based on pixel position value
		LocalMu=LocalMu+Mu*0.5
		
		-- Update the background meter height as the interpolated point
		SKIN:Bang("!SetOption",Meter[#Meter-1][j],"H",CubicInterpolate(y0,y1,y2,y3,LocalMu))
		
	end
	
	-- For each pixel in width of the last band
	for j=1,InterWidth do
		
		-- Request the interpolated point based on pixel position value
		LocalMu=LocalMu+Mu*0.5
		
		-- Update the background meter height as the interpolated point
		SKIN:Bang("!SetOption",Meter[#Meter][j],"H",CubicInterpolate(y0,y1,y2,y3,LocalMu))
		
	end
	
end