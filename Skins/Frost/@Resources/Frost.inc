[Rainmeter]
Update=16
DefaultUpdateDivider=-1
Group=#SkinGroup#
OnCloseAction=[!RefreshGroup #SkinGroup#]

ContextTitle="Open settings window"
ContextAction=#OpenSettingsWindow#
ContextTitle2="Edit variables"
ContextAction2=["#@#Variables.inc"]

[Variables]

; Since each skin file has some specific settings, they should be written to the global Variables file for access
EnvFlip=[!WriteKeyValue Variables Flip #Flip# "#@#Variables.inc"]
EnvHorizontal=[!WriteKeyValue Variables Horizontal #Horizontal# "#@#Variables.inc"]
EnvInvert=[!WriteKeyValue Variables Invert #Invert# "#@#Variables.inc"]
EnvChannel=[!WriteKeyValue Variables Channel #Channel# "#@#Variables.inc"]
EnvPort=[!WriteKeyValue Variables Port #Port# "#@#Variables.inc"]
EnvID=[!WriteKeyValue Variables ID "#ID#" "#@#Variables.inc"]
EnvConfig=[!WriteKeyValue Variables Config "#CURRENTCONFIG#" "#@#Variables.inc"]
EnvConfigPath=[!WriteKeyValue Variables ConfigPath "#CURRENTPATH##CURRENTFILE#" "#@#Variables.inc"]
EnvSettingsWindow=#EnvFlip##EnvHorizontal##EnvInvert#EnvChannel##EnvPort##EnvID##EnvConfig##EnvConfigPath#
OpenSettingsWindow=#EnvSettingsWindow#[!ActivateConfig "#ROOTCONFIG#\SettingsWindow"][!Refresh "#ROOTCONFIG#\SettingsWindow"]

[MeasureAudio]
Measure=Plugin
Plugin=AudioLevel
Port=#Port#
ID=#ID#
RMSAttack=0
RMSDecay=0
RMSGain=1
PeakAttack=0
PeakDecay=0
PeakGain=1
FFTSize=#FFTSize#
FFTOverlap=#FFTOverlap#
FFTAttack=#FFTAttack#
FFTDecay=#FFTDecay#
Bands=#Bands#
FreqMin=#FreqMin#
FreqMax=#FreqMax#
Sensitivity=#Sensitivity#
UpdateDivider=1

[DisableProcessCheck]
Measure=String
String=#MusicPlayer#
IfMatch="None"
IfMatchAction=[!SetOption DisableProcessCheck String 1][!UpdateMeasure DisableProcessCheck]
IfNotMatchAction=[!SetOption MeasureProcess UpdateDivider 62.5]

[MeasureProcess]
Measure=Plugin
Plugin=Process
ProcessName=#MusicPlayer#.exe

[Standby]
Measure=Plugin
Plugin=AudioLevel
Port=#Port#
ID=#ID#
RMSAttack=0
RMSDecay=0
RMSGain=1
PeakAttack=0
PeakDecay=0
PeakGain=1
UpdateDivider=1

; Toggle measures/meters based on idle audio and music player running status
IfCondition=((Standby > 0.00001) && ((DisableProcessCheck = 1) || (MeasureProcess = 1)))
IfTrueAction=[!EnableMeasure MeasureAudio][!EnableMeasure ScriptFrost][!EnableMeasure DynamicSensitivity][!EnableMeasure DynamicFFTDecay][!ShowFade]
IfFalseAction=[!DisableMeasure MeasureAudio][!DisableMeasure ScriptFrost][!DisableMeasure DynamicSensitivity][!DisableMeasure DynamicFFTDecay][!HideFade]

[DynamicSensitivity]
Measure=Calc
Formula=(#Sensitivity# - (MeasureAudio * 100 - #Sensitivity#))
IfCondition=((DynamicSensitivity > #Sensitivity#) && (#LoudnessEqualization# = 1))
IfTrueAction=[!SetOption MeasureAudio Sensitivity [DynamicSensitivity]]
IfConditionMode=1
UpdateDivider=1
; Average over the past 3 seconds to prevent stuttering
AverageSize=188

[DynamicFFTDecay]
Measure=Calc
Formula=(#FFTDecay# + (MeasureAudio * 100 - #Sensitivity#) * 10)
IfCondition=((DynamicSensitivity > #Sensitivity#) && (#LoudnessEqualization# = 1))
IfTrueAction=[!SetOption MeasureAudio FFTDecay [DynamicFFTDecay]]
IfConditionMode=1
UpdateDivider=1
AverageSize=188

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
OnUpdateAction=[!Redraw]

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