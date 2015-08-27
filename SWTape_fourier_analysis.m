% SWTape_fourier_analysis.m

% This script performs a fourier analysis on the 13.8 cms of height data
% gathered from safety walk tape.  Tries to determine key spatial
% frequencies and their associated heights.

% Inputs:

% SWTape_Height_um.txt - contains height of safety walk tape contour at
% each mm of tape measured.  Columns = [sample #, area, angle, length].
% Height measurements are in um (microns).

clear
clc

%% LOAD DATA

drive = 'C:\Users\Diana\Documents\work\Stanford\Microalgae\Radula Images\safety walk tape images\';
% location of files on DLG's computer

name = 'SWTape_Height_um.txt';
% name of file containing safety walk tape contour data

filename = [drive name];
height_data = load(filename);

%% DIVIDE DATA

height_data = height_data(:,4);
% select out the height data only

height_data1 = height_data(1:23);
height_data2 = height_data(24:46);
height_data3 = height_data(47:69);
height_data4 = height_data(70:92);
height_data5 = height_data(93:115);
height_data6 = height_data(116:138);
% divide data set into 6 equal chuncks (each chunk is 23mm - 2.3cm - long)

%% RUN FOURIER TRANSFORMS

[freq1, pwr1] = fourier(height_data1, 1);
[freq2, pwr2] = fourier(height_data2, 1);
[freq3, pwr3] = fourier(height_data3, 1);
[freq4, pwr4] = fourier(height_data4, 1);
[freq5, pwr5] = fourier(height_data5, 1);
[freq6, pwr6] = fourier(height_data6, 1);
% use fourier.m to find the frequency and power for each chunk

%% AVERAGE OUTPUT

freq_matrix = [freq1
    freq2
    freq3
    freq4
    freq5
    freq6];
freq = mean(freq_matrix);

pwr_matrix = [pwr1, pwr2, pwr3, pwr4, pwr5, pwr6];
pwr = mean(pwr_matrix, 2);
% average frequency and power across 6 subsamples

pwr_error = std(pwr_matrix, 0, 2);
% calculate error (standard deviation)

%% PLOT

figure()
errorbar(freq, pwr, pwr_error)
xlabel('Spatial Frequency [1/mm]')
ylabel('Power')
title('Spectral Analysis of Safety Walk Tape Contour (error bars = 1 stdev)')


