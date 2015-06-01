[Rainmeter]
Update=16
DefaultUpdateDivider=-1
Group=Frost
RightMouseDownAction=[!SkinCustomMenu]

ContextTitle="Change color..."
ContextAction=[!ActivateConfig "Frost\InputSolidColor"]
ContextTitle2="Display settings..."
; Each skin file uses a specific flip setting
ContextAction2=[!WriteKeyValue Variables Flip #Flip# "#@#Variables.inc"][!WriteKeyValue Variables Config "#CURRENTCONFIG#" "#@#Variables.inc"][!WriteKeyValue Variables ConfigPath "#CURRENTPATH##CURRENTFILE#" "#@#Variables.inc"][!ActivateConfig "Frost\ContextMenus" "Display.ini"]
ContextTitle3="Audio settings..."
ContextAction3=[!WriteKeyValue Variables Config "#CURRENTCONFIG#" "#@#Variables.inc"][!WriteKeyValue Variables ConfigPath "#CURRENTPATH##CURRENTFILE#" "#@#Variables.inc"][!ActivateConfig "Frost\ContextMenus" "Audio.ini"]
ContextTitle4=---
ContextTitle5="Edit local settings..."
ContextAction5=["Notepad" "#CURRENTPATH##CURRENTFILE#"]
ContextTitle6="Edit global settings..."
ContextAction6=["Notepad" "#@#Variables.inc"]

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
IfTrueAction=[!DisableMeasure MeasureAudio][!DisableMeasure ScriptFrost][!HideMeterGroup Bars][!HideMeter BoundingBox]

[Standby]
Measure=Plugin
Plugin=AudioLevel
Port=#Port#
ID=#ID#
UpdateDivider=1
IfConditionMode=1

; Show meters and enable measures when sound begins playing
IfCondition=(Standby > 0.000000000000000001)
IfTrueAction=[!EnableMeasure MeasureAudio][!EnableMeasure ScriptFrost][!ShowMeterGroup Bars][!ShowMeter BoundingBox]

; Gradient bar meter is always full when measure value is 1
[One]
Measure=Calc
Formula=1

; Include band measures and meters
@Include=#@#BandMeasures.inc
@Include2=#@#BandMeters.inc

[ScriptFrost]
Measure=Script
ScriptFile=#@#Frost.lua
Sub=Repeat
Index=1
Limit=(#Bands#-1)
MeasureName=MeasureAudioRepeat
MeterName=MeterBarRepeat
UpdateDivider=1

[SetMeasureOptions]
Measure=Calc
OnUpdateAction=[!SetOptionGroup Audio Channel #Channel#][!SetOptionGroup Audio AverageSize #AverageSize#][!SetOptionGroup Audio UpdateDivider 1][!UpdateMeasureGroup Audio]

[SetMeterOptions]
Measure=Script
ScriptFile=#@#SetMeterOptions.lua
Sub=Repeat
MeterName=MeterBarRepeat

; Reveal the transformation through an invisible meter
[BoundingBox]
Meter=Bar
W=(#Width#*#Scale#)
H=(#Height#*#Scale#)
BarColor=255,255,255,0
MeasureName=One