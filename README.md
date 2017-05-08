# EE2020-Signal-Generator

Signal generator in Verilog HDL for Basys3 for EE2020.

Sinusoidal wave employs the Xilinx CORDIC core. However, a look-up table is also included. Edit the code to use the look-up table if IP core is not available.

This project was completed as part of the module EE2020 Digital Fundamentals. The code is incomplete and may never be completed. Use it as a reference but please note that nothing here has been optimised for any purpose.

## User Guide

<table>
  <tr>
    <th>FEATURE</th>
    <th>INPUT</th>
    <th>DESCRIPTION</th>
    <th>OUTPUT DISPLAY</th>
  </tr>
  <tr>
    <td rowspan="3">Wave Selection</td>
    <td>SWITCH[15]</td>
    <td>Turn on switch to select waveform and mode.</td>
    <td>VGA display shows "CHANGE WAVEON".</td>
  </tr>
  <tr>
    <td>+LEFT/RIGHT</td>
    <td>Scroll between different waveforms: square, sawtooth, triangle and sinusoidal.</td>
    <td>VGA display shows the "WAVEFORM"currently selected.</td>
  </tr>
  <tr>
    <td>+UP/DOWN</td>
    <td>Scroll between different modes: normal, half-wave rectification,reversed, full-wave rectification.</td>
    <td>VGA display shows the "MODE" selected.</td>
  </tr>
  <tr>
    <td rowspan="2">Keyboard Input</td>
    <td>SWITCH[14]</td>
    <td>.Turn on switch to enter frequency using a USB keyboard</td>
    <td>VGA display shows "KEYBOARD ON".</td>
  </tr>
  <tr>
    <td>+KEYBOARD NUMBERS</td>
    <td>Enter five numbers to set frequency to that value.</td>
    <td>Seven-segment display shows the frequency value in Hz if frequency is 9999Hz and below and in kHz if frequency is 10 kHz and above. VGA display shows the "FREQUENCY" value.</td>
  </tr>
  <tr>
    <td>Maximum Amplitude Modulation</td>
    <td>SWITCH[13]</td>
    <td>Turn on switch to modulate the first channel using the maximum amplitude of the second channel as the carrier.</td>
    <td>VGA display shows "MAX AMP MOD ON".</td>
  </tr>
  <tr>
    <td>Maximum and Minimum Amplitude Modulation</td>
    <td>SWITCH[12]</td>
    <td>Turn on switch to modulate the first channel using the minimum and maximum amplitude of the second channel as the carrier.</td>
    <td>VGA display shows "MIN MAX MOD ON".</td>
  </tr>
  <tr>
    <td rowspan="3">Frequency Modulation and Bandwidth Selection</td>
    <td>SWITCH[11]</td>
    <td>Turn on switch to modulate the first channel using the frequency of the second channel as the carrier.</td>
    <td>VGA display shows "FREQ MOD ON".</td>
  </tr>
  <tr>
    <td>+SWITCH[10]</td>
    <td>Turn on to change the percentage bandwidth used for the frequency modulation from 0% to 100% with step-size 5%.</td>
    <td>VGA display shows "BANDWIDTH"</td>
  </tr>
  <tr>
    <td>+LEFT/RIGHT</td>
    <td>Decrease/Increase bandwidth for frequency modulation.</td>
    <td>VGA display shows bandwidth value.</td>
  </tr>
  <tr>
    <td>Phase Modulation</td>
    <td>SWITCH[10]</td>
    <td>Turn on switch to modulate the first channel using the phase of the second channel as the carrier.</td>
    <td>VGA display shows "PHASE MOD ON".</td>
  </tr>
  <tr>
    <td>Superposition</td>
    <td>SWITCH[9]</td>
    <td>Turn on switch to output the superposition of Channel 1 and Channel 2.</td>
    <td>VGA display shows "SUPERPOSITION ON".</td>
  </tr>
  <tr>
    <td rowspan="6">Change Frequency Increment Step</td>
    <td>SWITCH[8]</td>
    <td>Turn on to change frequency increment/decrement to the most significant digit (1000 Hz at 9999 Hz and below &amp; 10 kHz at 10 kHz and above).</td>
    <td></td>
  </tr>
  <tr>
    <td>+LEFT/RIGHT</td>
    <td>Decrease/Increase frequency by 1000 Hz at 9999 Hz and below &amp; 10 kHz at 10 kHz and above.</td>
    <td>Seven-segment display shows the frequency value in Hz if frequency is 9999 Hz and below and in kHz if frequency is 10 kHz and above. VGA display shows the "FREQUENCY" value.</td>
  </tr>
  <tr>
    <td>SWITCH[7]</td>
    <td>Turn on to change frequency increment/decrement to the second most significant digit (100 Hz at 9999 Hz and below &amp; 1 kHz at 10 kHz and above).</td>
    <td></td>
  </tr>
  <tr>
    <td>+LEFT/RIGHT</td>
    <td>Decrease/Increase frequency by 100 Hz at 9999 Hz and below &amp; 1 kHz at 10 kHz and above.</td>
    <td>Seven-segment display shows the frequency value in Hz if frequency is 9999 Hz and below and in kHz if frequency is 10 kHz and above. VGA display shows the "FREQUENCY" value.</td>
  </tr>
  <tr>
    <td>SWITCH[6]</td>
    <td>Turn on to change frequency increment/decrement to the third most significant digit (10 Hz at 9999 Hz and below &amp; 0.1 kHz at 10 kHz and above).</td>
    <td></td>
  </tr>
  <tr>
    <td>+LEFT/RIGHT</td>
    <td>Decrease/Increase frequency by 10 Hz at 9999 Hz and below &amp; 0.1 kHz at 10 kHz and above.</td>
    <td>Seven-segment display shows the frequency value in Hz if frequency is 9999 Hz and below and in kHz if frequency is 10 kHz and above. VGA display shows the "FREQUENCY" value.</td>
  </tr>
  <tr>
    <td>Bit Display for Amplitudes</td>
    <td>SWITCH[5]</td>
    <td>Turn on to change amplitude display from voltage to the corresponding bit value from 0 to 4095.</td>
    <td>Seven-segment display shows the amplitude value in bit-value. VGA display shows the "MAX AMPLITUDE" and "MIN AMPLITUDE" values in bit-value.</td>
  </tr>
  <tr>
    <td rowspan="2">Duty Cycle</td>
    <td>SWITCH[4]</td>
    <td>Turn on to change the percentage duty cycle for square wave or triangle wave from 0% to 100% with step-size 5%.</td>
    <td>VGA display shows "DUTY CYCLE".</td>
  </tr>
  <tr>
    <td>+LEFT/RIGHT</td>
    <td>Decrease/Increase duty cycle for square wave or triangle wave.</td>
    <td>VGA display shows duty cycle value.</td>
  </tr>
  <tr>
    <td>Second Channel</td>
    <td>SWITCH[3]</td>
    <td>Turn on to switch to the second channel to change the output parameters of Channel 2. Switches and buttons to change parameters is similar to Channel 1.</td>
    <td>VGA display shows "&lt;" next to "CHANNEL 2".</td>
  </tr>
  <tr>
    <td rowspan="2">DC Offset</td>
    <td>SWITCH[2]</td>
    <td>Turn on to change the DC offset for any wave.</td>
    <td>VGA display shows "&lt;" next to both "MIN" and "MAX".</td>
  </tr>
  <tr>
    <td>+UP/DOWN</td>
    <td>Increase/Decrease the DC offset for any wave.</td>
    <td>Seven-segment display shows the maximum amplitude. VGA display shows the "MAX AMPLITUDE" and "MIN AMPLITUDE" values.</td>
  </tr>
  <tr>
    <td rowspan="3">Independent Minimum and Maximum Amplitudes</td>
    <td>SWITCH[1]</td>
    <td>Turn on to change the maximum amplitude. Turn off to change the minimum amplitude.</td>
    <td>VGA displays "&lt;" next to "MIN" when SWITCH[1] is off and "&lt;" next to "MAX" when SWITCH[1] is on.</td>
  </tr>
  <tr>
    <td>+UP/DOWN</td>
    <td>Increase/Decrease maximum or minimum amplitude.</td>
    <td>Seven-segment display shows the maximum or minimum ampltude. VGA display shows the "MAX AMPLITUDE" and "MIN AMPLITUDE" values.</td>
  </tr>
  <tr>
    <td>+HOLD</td>
    <td>Hold UP/DOWN to speed up the rate of increase/decrease.</td>
    <td></td>
  </tr>
  <tr>
    <td>DC Output</td>
    <td>SWITCH[0]</td>
    <td>Turn on switch to immediately output a DC voltage at the maximum amplitude of the current channel.</td>
    <td>VGA display shows "DC" next to the channel.</td>
  </tr>
  <tr>
    <td rowspan="2">Frequency Control</td>
    <td>LEFT/RIGHT</td>
    <td>Decrease/Increase the frequency.</td>
    <td>Seven-segment display shows the frequency value in Hz if frequency is 9999 Hz and below and in kHz if frequency is 10 kHz and above. VGA display shows the "FREQUENCY" value.</td>
  </tr>
  <tr>
    <td>+HOLD</td>
    <td>Hold LEFT/RIGHT to speed up the rate of increase/decrease.</td>
    <td></td>
  </tr>
  <tr>
    <td>Reset Phase Accumulator</td>
    <td>CENTRE</td>
    <td>Reset the phase accumulator for both channels.</td>
    <td></td>
  </tr>
  <tr>
    <td>Adaptive Seven-segment</td>
    <td></td>
    <td></td>
    <td>Seven-segment display adapts automatically. When changing amplitudes, it displays the corresponding amplitude. When changing frequency, it displays the corresponding frequency.</td>
  </tr>
  <tr>
    <td>LED Display</td>
    <td></td>
    <td></td>
    <td>LEDs display the output in bit-values in real-time.</td>
  </tr>
  <tr>
    <td>Frequency Range</td>
    <td></td>
    <td>Frequency range from 0 Hz to 50 kHz with step-size 1 Hz from 0 Hz to 9999 Hz and 0.01 kHz from 10 kHz to 50 kHz.</td>
    <td>Seven-segment display shows the frequency value in Hz if frequency is 9999 Hz and below and in kHz if frequency is 10 kHz and above. VGA display shows the "FREQUENCY" value.</td>
  </tr>
</table>

## Code Adaptations

### VGA
"To display a square on monitor ( Verilog vga Basys 2 board )", Forum for Electronics, 2017. [Online].
Available: http://www.edaboard.com/thread324748.html. [Accessed: 20- Mar- 2017].

### Keyboard
"PS2 Keyboard", Students’ Gymkhana IIT Kanpur, 2017. [Online].
Available: http://students.iitk.ac.in/eclub/assets/tutorials/keyboard.pdf. [Accessed: 14- Mar- 2017].

### Seven-segment Display
"Seven Segment LED Multiplexing Circuit in Verilog", Simplefpga.blogspot.sg, 2017. [Online].
Available: http://simplefpga.blogspot.sg/2012/07/seven-segment-led-multiplexing-circuit.html. [Accessed: 10- Mar- 2017].