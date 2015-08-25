[Variables]

Bands=36
; Number of peaks to interpolate between - Activate Frost\GenerateMeasures skin after changing this value

Color=192,224,192
; Don't add an alpha value at the end

Width=491
Height=175
; "Real" spectrum dimensions - Activate Frost\GenerateMeters skin after changing these values

Scale=2
; Magnification of the real spectrum, increasing viewing size and performance at the expense of quality

SmoothEnds=1
; Smooth the ends of the spectrum towards zero

AverageSize=4
; "Smoothness" - Number of past measure values used to increase continuity

FFTSize=6144
FFTOverlap=(#FFTSize#*0.5)
FFTAttack=0
FFTDecay=275
FreqMin=20
FreqMax=20000
Sensitivity=30
; http://docs.rainmeter.net/manual-beta/plugins/audiolevel

FirstBandIndex=1

; Environment variables for settings window
SkinGroup=Frost
Config=Frost
ConfigPath=#ROOTCONFIGPATH#Frost.ini
WriteVariable=Color
Flip=0
Horizontal=0
Invert=0
Channel=Avg
Port=Output
ID=
