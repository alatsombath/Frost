-- Frost v2.0
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

function Initialize()
  floor = math.floor
  measure, measureBuffer, meter, cacheDimSize = {}, {}, {}, {}
  interpolateSpan = SELF:GetNumberOption("InterpolateSpan")
  mu = 1 / interpolateSpan
  spectrumSize, meterDimSize = SELF:GetNumberOption("SpectrumSize"), SELF:GetNumberOption("MeterDimSize")
  smoothEnds = SELF:GetNumberOption("SmoothEnds")
  setH = SELF:GetNumberOption("SetH")
  meterIter, hLowerLimit, hUpperLimit = 1, SELF:GetNumberOption("hLowerLimit") + 1, SELF:GetNumberOption("hUpperLimit") + 1
  for i = hLowerLimit, hUpperLimit do
    meter[i], cacheDimSize[i], measure[i] = {}, {}, SKIN:GetMeasure(SELF:GetOption("MeasureBaseName") .. i-1) 
    for j = 1, interpolateSpan do
      cacheDimSize[i][j], meterIter, meter[i][j] = 0, meterIter + 1, SKIN:GetMeter(SELF:GetOption("MeterBaseName") .. meterIter)
    end
  end
end

-- http://paulbourke.net/miscellaneous/interpolation/
local function CubicInterpolate(y0,y1,y2,y3,mu)
   local mu2,a0 = mu*mu, y3-y2-y0+y1
   local a1 = y0-y1-a0
   return (a0*mu*mu2+a1*mu2+(y2-y0)*mu+y1)
end
  
function Update()
  for i = hLowerLimit, hUpperLimit do measureBuffer[i] = measure[i]:GetValue() end
  if smoothEnds ~= 0 then
    measureBuffer[hLowerLimit], measureBuffer[hLowerLimit+1], measureBuffer[hUpperLimit-1], measureBuffer[hUpperLimit] = 0, 0, 0, 0
    measureBuffer[hLowerLimit+2] = 0.33 * (measureBuffer[hLowerLimit+2])
    measureBuffer[hLowerLimit+3] = 0.66 * (measureBuffer[hLowerLimit+2] + measureBuffer[hLowerLimit+3])
    measureBuffer[hUpperLimit-2] = 0.33 * (measureBuffer[hUpperLimit-2])
    measureBuffer[hUpperLimit-3] = 0.66 * (measureBuffer[hUpperLimit-2] + measureBuffer[hUpperLimit-3])
  end
  
  local spectrumSize = spectrumSize
  for i = hLowerLimit, hUpperLimit-1 do
    local localMu, meter = 0, meter[i]
    local y0, y3 = measureBuffer[i-1 < hLowerLimit and hLowerLimit or i-1] * meterDimSize, measureBuffer[i+2 > hUpperLimit and hUpperLimit or i+2] * meterDimSize
	local y1, y2 = measureBuffer[i] * meterDimSize, measureBuffer[i+1] * meterDimSize
    for j = 1, interpolateSpan do
      localMu = localMu + mu
      local dimSize = floor(CubicInterpolate(y0,y1,y2,y3,localMu) + 0.5)
      if dimSize ~= cacheDimSize[i][j] then
        cacheDimSize[i][j] = dimSize
        if setH ~= 0 then
		  meter[j]:SetH(dimSize)
		else
		  meter[j]:SetW(dimSize)
		end
      end
	  spectrumSize = spectrumSize - 1
	  if spectrumSize == 0 then
	    return 0
	  end
    end
  end
end