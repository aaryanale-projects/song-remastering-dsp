# Song-remastering using Digital Signal Processing 

## Dependencies
- eq_app.mlapp – The main user interface for the equalizer and remastering tool.
- filter_design.m – Initializes the digital filters required by the equalizer.
- test_functions.m – Contains DSP functions used in the remastering process.
- Second_Gaussian.m – Applies an additional Gaussian window after the DSP processing.
- Sharpening_Filter.m – Uses a selected impulse response (IR) to sharpen the song.
- delta_length_720000.wav – Example impulse response file for use with Sharpening_Filter.m.
- delta_length_1323000.wav – Another impulse response file option for Sharpening_Filter.m.
- sample_one_original.wav – Sample input audio file for testing (any other file can also be used).
- demo.m – A short demonstration script that remasters sample_one_original.wav and outputs demo_out.wav.

## Steps to use
- Open the Interface: Double-click on eq_app.mlapp (MATLAB will open if not already running).
- Set Input File: In the lower-right corner of the UI, enter the input file name (including its extension).
- Specify Song Length: In the “Length” box, enter the portion of the song you want to process. (Must be ≤ the actual song duration.)
- Adjust Gain (Optional): Enter your desired amplification factor in the “Gain” box. (Default = 1)
- Set Window Size: Enter the preferred processing window size in the “Window Size” box. (Default and recommended = 100000)
- Select Impulse Response: Choose which IR file to use. For sample_one_original.wav, use delta_length_1323000.wav for best results.
- Generate Output: Click “Generate”. The status will show “Running” while processing.
- Retrieve Output: When the status changes to “Completed”, a new file named song_output.wav will appear in your directory.

## Description
Remastering old songs using Digital Signal Processing (DSP) techniques focuses on improving the fidelity and clarity of original audio recordings. Many legacy tracks, often sourced from analog media, suffer from noise, distortion, and limited frequency response due to the constraints of past recording technologies. Through the application of advanced DSP methods such as noise reduction, equalization, dynamic range compression, and adaptive filtering, the audio can be cleaned, balanced, and refined. This process enhances the listening experience and brings the sound quality closer to modern standards, while carefully preserving the original artistic character and intent of the music.

