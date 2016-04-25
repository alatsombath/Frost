[Variables]

Bands=21
; Number of peaks - Activate Frost\GenerateMeasures skin after changing this value

Color=192,224,192

Width=300
Height=100
; "Real" spectrum dimensions - Activate Frost\GenerateMeters skin after changing these values

Scale=2
; Increases viewing size and performance at the expense of quality

SmoothEnds=0
; Prevents the waveform from clipping at the edges

AverageSize=0
; Average sound levels over time to provide continuity

LoudnessEqualization=1
; Increases visibility for quiet audio sources when applicable

FFTSize=6144
FFTOverlap="(#FFTSize#-512)"
FFTAttack=0
FFTDecay=240
FreqMin=30
FreqMax=10000
Sensitivity=24
; http://docs.rainmeter.net/manual-beta/plugins/audiolevel

MusicPlayer=None
; Music player process name, such as "VLC" (not "VLC.exe")

FirstBandIndex=1
; "0" band should be skipped for aesthetic purpose

IdleAudioTimeout=1
; How long before hiding the visualizer when no sound is playing

; Environment variables for settings window
SkinGroup=Frost
Config=Frost
ConfigPath=#ROOTCONFIGPATH##Config#.ini
WriteVariable=Color
Flip=0
Horizontal=0
Invert=0
Channel=Avg
Port=Output
ID=
