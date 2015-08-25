[Rainmeter]
Update=16
DefaultUpdateDivider=-1
Group=#SkinGroup#
OnCloseAction=[!RefreshGroup #SkinGroup#]

; Since each skin file has some specific settings, their config name and settings should be written to the global Variables file for access
ContextTitle="Open settings window"
ContextAction=[!WriteKeyValue Variables Flip #Flip# "#@#Variables.inc"][!WriteKeyValue Variables Horizontal #Horizontal# "#@#Variables.inc"][!WriteKeyValue Variables Invert #Invert# "#@#Variables.inc"][!WriteKeyValue Variables Channel #Channel# "#@#Variables.inc"][!WriteKeyValue Variables Port #Port# "#@#Variables.inc"][!WriteKeyValue Variables ID "#ID#" "#@#Variables.inc"][!WriteKeyValue Variables Config "#CURRENTCONFIG#" "#@#Variables.inc"][!WriteKeyValue Variables ConfigPath "#CURRENTPATH##CURRENTFILE#" "#@#Variables.inc"][!ActivateConfig "#ROOTCONFIG#\SettingsWindow"]
ContextTitle2="Edit variables"
ContextAction2=["#@#Variables.inc"]

[MeasureAudio]
Measure=Plugin
Group=Audio
Plugin=AudioLevel
Port=#Port#
ID=#ID#
FFTSize=#FFTSize#
FFTOverlap=#FFTOverlap#
FFTAttack=#FFTAttack#
FFTDecay=#FFTDecay#
Bands=#Bands#
FreqMin=#FreqMin#
FreqMax=#FreqMax#
Sensitivity=#Sensitivity#
UpdateDivider=1

; Hide meters and disable measures when idle
IfCondition=(MeasureAudio < 0.000000000000000001)
IfTrueAction=[!DisableMeasure MeasureAudio][!DisableMeasure ScriptFrost][!HideMeterGroup Rotators][!HideMeter BoundingBox]

[Standby]
Measure=Plugin
Plugin=AudioLevel
Port=#Port#
ID=#ID#
UpdateDivider=1
IfConditionMode=1

; Show meters and enable measures when sound begins playing
IfCondition=(Standby > 0.000000000000000001)
IfTrueAction=[!EnableMeasure MeasureAudio][!EnableMeasure ScriptFrost][!ShowMeterGroup Rotators][!ShowMeter BoundingBox]

@Include=#@#BandMeasures.inc
@Include2=#@#BandMeters.inc

[SetMeasureOptions]
Measure=Calc
OnUpdateAction=[!SetOptionGroup Audio Channel #Channel#][!SetOptionGroup Audio AverageSize #AverageSize#][!SetOptionGroup Audio UpdateDivider 1][!UpdateMeasureGroup Audio]

[SetMeterOptions]
Measure=Script
ScriptFile=#@#SetMeterOptions.lua

[ScriptFrost]
Measure=Script
ScriptFile=#@#Frost.lua
MeasureBaseName=MeasureAudio
MeterBaseName=MeterRotator
hLowerLimit=#FirstBandIndex#
hUpperLimit=(#Bands#-1)
InterpolateSpan=(Ceil(#Width# / (#Bands# - #FirstBandIndex# - 1)))
SpectrumSize=#Width#
MeterDimSize=#Height#
SmoothEnds=#SmoothEnds#
SetH=(#Horizontal# = 0 ? 1 : 0)
UpdateDivider=1

[Matrix]
Measure=String
String="(#Horizontal# = 0 ? #Scale# : (#Flip# = 0 ? #Scale# : -#Scale#));0;0;(#Horizontal# = 0 ? (#Flip# = 0 ? -#Scale# : #Scale#) : #Scale#);(#Horizontal# = 0 ? 0 : (#Flip# = 0 ? 0 : (#Height# * #Scale#)));(#Horizontal# = 0 ? (#Flip# = 0 ? (#Height# * #Scale#) : 0) : 0)"

; Reveal the transformation by expanding the skin window through an invisible meter
[BoundingBox]
Meter=Image
W=((#Horizontal# = 0 ? #Width# : #Height#) * #Scale#)
H=((#Horizontal# = 0 ? #Height# : #Width#) * #Scale#)

[MeasureZero]
Measure=Calc
Formula=0