Perspective_Version   1
#
pref::section perspective 
set perspective_Name      qverify
set perspective_DateTime  2021-12-03T21:33:23
set perspective_Directory /u/pratik2/ECE560/DMA_Controller_Assertion_Based_Verification
set perspective_USER      pratik2
set perspective_VisId   10.7b-QCF
pref::section layout 
# . . .
# . . .
#
pref::section preference 
pref::set -type bool -category General -name PromptForWavefile -value false -description {Operations that require a wave file will trigger a prompt for wave file if this value is true,
otherwise the operation will be disabled} -label {Prompt for wavefile as needed}
pref::set -type string -category General -name Perspective -value qverify -hide
pref::set -type font -category General.Font -name ApplicationFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Specifies the application font to use if the preference to
override the system default font is true} -label {Application Font}
pref::set -type font -category General.Font -name WindowFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Specifies the font for window titles} -label {Window Font}
pref::set -type font -category General.Font -name TooltipFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Specifies the font for tooltips} -label {Tooltip Font}
pref::set -type bool -category Waveform -name PanToCursor -value false -description {Pan wave window to primary cursor time if true} -label {Pan to Primary Cursor Time}
pref::set -type font -category Waveform.Font -name WaveformFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Font used within wave window for signal, names, values, etc.} -label {Waveform Font}
pref::set -type category -value Schematic
pref::set -type category -value Design
pref::set -type category -value {Browse Menu}
pref::set -type category -value Files
pref::set -type category -value {UVM Testbench}
pref::set -type category -value Breakpoints
pref::set -type category -value CallStack
pref::set -type category -value Classes
pref::set -type category -value {Class Instance}
pref::set -type category -value Locals
pref::set -type category -value {Memory Usage}
pref::set -type category -value Sequence
pref::set -type category -value Threads
pref::set -type category -value {UVM Configuration}
pref::set -type category -value {UVM Factory}
pref::set -type category -value Watch
pref::set -type category -value {Delta List}
pref::set -type category -value PropCheck
pref::set -type bool -category PropCheck -name confirmExitStopsRun -value true -description {<p style='white-space: pre'>Show confirmation when exiting and a run is in-progress.<br>Unselecting this option will automatically terminate<br>a run that is in-progress.} -label {Confirm exiting will stop an in-progress run}
pref::set -type string -category PropCheck -name formalControlPointsRadixType -value b -hide -description none -label none
pref::set -type category -value PropCheck.Color
pref::set -type color -category PropCheck.Color -name contribWaveAnnoColor -value #3c5e36 -description {<p style='white-space: pre'>Color used in wave window to identify ranges of times for which<br>a contributing signal's values are relevant for the firing.<br>Note: Change not applied to currently visible waveforms.} -label {Contributor time regions}
pref::set -type category -value PropCheck.Properties
pref::set -type bool -category PropCheck.Properties -name showContribs -value false -description {Include contributor signals when showing waveforms} -label {Show contributor signals}
pref::set -type bool -category PropCheck.Properties -name dontCaresX -value false -description {<p style='white-space: pre'>By default, waveforms use 0's for the don't care<br>values. This option applies X's instead. The X's<br>propagate using the semantic rules for X propagation.} -label {Use X for don't care values on control points}
pref::set -type int -category PropCheck.Properties -name extraCycles -value 1 -description {<p style='white-space: pre'>Include in the waveform the specified number<br>of cycles after the cycle with the firing} -label {Number of cycles after firing}
pref::set -type bool -category PropCheck.Properties -name showCountsSummary -value false -hide -description none -label none
Perspective_Complete
