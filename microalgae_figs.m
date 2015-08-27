% microalgae_figs.m

% Diana LaScala-Gruenewald
% 7/9/15
% R2014a

% Creates figures for microalgae paper.

clear
clc

%% LOAD DATA

drive = 'C:\Users\Diana\Documents\work\Stanford\Microalgae\Data\'; % Ender

filename1 = [drive 'Averaged_Photoquad_Data_MATLAB.csv'];
filename2 = [drive 'Averaged_by_groups_MATLAB.csv'];
filename3 = [drive 'Environmental_Data.csv'];
filename4 = [drive 'MDS_groups.txt'];
filename5 = [drive 'MDS_morphotypes.txt'];
filename6 = [drive '2014_summer_CN_ratios_from_Bracken_with_treats.csv'];

treatment_bio_data = load(filename1);
group_bio_data = load(filename2);
enviro_data = load(filename3);
mds_groups = load(filename4);
mds_morpho = load(filename5);

% load filename6:

delimiter = ',';
startRow = 2;
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename6,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,7,8,9,11,12,14,15,16]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,2,3,7,8,9,11,12,14,15,16]);
rawCellColumns = raw(:, [4,5,6,10,13]);

% Create output variable
CNratios = table;
CNratios.PlateNum = cell2mat(rawNumericColumns(:, 1));
CNratios.Plate = cell2mat(rawNumericColumns(:, 2));
CNratios.Site = cell2mat(rawNumericColumns(:, 3));
CNratios.ShoreLevel = rawCellColumns(:, 1);
CNratios.TempTreat = rawCellColumns(:, 2);
CNratios.LimpetTreat = rawCellColumns(:, 3);
CNratios.Density = cell2mat(rawNumericColumns(:, 4));
CNratios.Triplet = cell2mat(rawNumericColumns(:, 5));
CNratios.limpetspresent = cell2mat(rawNumericColumns(:, 6));
CNratios.ProcessingDate = rawCellColumns(:, 4);
CNratios.Nitrogen = cell2mat(rawNumericColumns(:, 7));
CNratios.Carbon = cell2mat(rawNumericColumns(:, 8));
CNratios.quality = rawCellColumns(:, 5);
CNratios.CNratio = cell2mat(rawNumericColumns(:, 9));
CNratios.avdailymax = cell2mat(rawNumericColumns(:, 10));
CNratios.Fo = cell2mat(rawNumericColumns(:, 11));

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns;

%% FIGURE 2

treatment = {'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', ...
    'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D'};

% create figure and plot data
figure()
boxplot(enviro_data(:,2), treatment, 'colors', 'k', 'symbol', '');
xlabel('Treatment', 'FontSize', 12)
ylabel('F_0', 'FontSize', 12)
title('The Effect of Grazing Treatment on Fluorescence', 'FontSize', 14, ...
    'FontWeight', 'bold')

% add a key
box = text('String', {'A = ungrazed', 'B = community grazed', ...
    ['C = ' '\it L. scabra\rm' '-grazed'], ...
    ['D = ', '\it L. austrodigitalis\rm' '-grazed']}, 'EdgeColor', 'k', ...
    'Position', [2.8, 154])

% add lines and stars
line([1.8,4.2], [95,95], 'Color', 'k')
line([1], [167], 'Marker', '*', 'MarkerEdgeColor', 'k', 'MarkerSize', 8)
line([3], [100], 'Marker', '*', 'MarkerEdgeColor', 'k', 'MarkerSize', 8)

%% FIGURE 3

h = figure(1)
set(h, 'Position', [230 200 1000 700])

hold on
scatter(mds_groups([1 5 9 13 17 21],1), mds_groups([1 5 9 13 17 21],2), ...
    'ko', 'MarkerFaceColor', 'k')
scatter(mds_groups([2 6 10 14 18 22],1), mds_groups([2 6 10 14 18 22],2), ...
    'ks', 'MarkerFaceColor', [0.396 0.396 0.396])
scatter(mds_groups([3 7 11 15 19 23],1), mds_groups([3 7 11 15 19 23],2), ...
    'kd', 'MarkerFaceColor', [0.756 0.756 0.756])
scatter(mds_groups([4 8 12 16 20 24],1), mds_groups([4 8 12 16 20 24],2), ...
    'kp', 'MarkerFaceColor', [0.92 0.92 0.92])
axis([-3 1.7 -1.2 1.5])
axis off
legend('Ungrazed', 'Community-grazed', ['\it L. scabra\rm' '-grazed'], ...
    ['\it L. austrodigitalis\rm' '-grazed'])
title('Effects of Grazing Treatment on Group-Level Community Composition', 'FontSize', 14, ...
    'FontWeight', 'bold')

ellipse(1.9, 0.9, 0.3, -1, 0, 'k') 
ellipse(1.3, 0.7, 2.7, 0, 0, [0.396 0.396 0.396])
ellipse(0.7, 0.4, 0, 0.6, 0.1, [0.756 0.756 0.756])
ellipse(1, 0.7, 0.7, 0.4, -0.2, [0.92 0.92 0.92])

% draw bounding rectangle
rectangle('Position', [-2.9, -1.1, 4.5, 2.5])

%% FIGURE 4

h = figure(1)
set(h, 'Position', [230 200 1000 700])

hold on
scatter(mds_morpho([1 5 9 13 17 21],1), mds_morpho([1 5 9 13 17 21],2), ...
    'ko', 'MarkerFaceColor', 'k')
scatter(mds_morpho([2 6 10 14 18 22],1), mds_morpho([2 6 10 14 18 22],2), ...
    'ks', 'MarkerFaceColor', [0.396 0.396 0.396])
scatter(mds_morpho([3 7 11 15 19 23],1), mds_morpho([3 7 11 15 19 23],2), ...
    'kd', 'MarkerFaceColor', [0.756 0.756 0.756])
scatter(mds_morpho([4 8 12 16 20 24],1), mds_morpho([4 8 12 16 20 24],2), ...
    'kp', 'MarkerFaceColor', [0.92 0.92 0.92])
axis([-2.5 2 -1.6 1.5])
axis off
legend('Ungrazed', 'Community-grazed', ['\it L. scabra\rm' '-grazed'], ...
    ['\it L. austrodigitalis\rm' '-grazed'])
title('Effects of Grazing Treatment on Morphotype-Level Community Composition', 'FontSize', 14, ...
    'FontWeight', 'bold')

% draw ellipses
ellipse(1.4, 0.7, 1.05, 0.8, -0.2, 'k') 
ellipse(1.3, 0.7, 0, 0, 0.1, [0.396 0.396 0.396])
ellipse(1.2, 0.4, 0, -1, 0, [0.756 0.756 0.756])
ellipse(1.3, 0.7, 0.2, -0.7, 0, [0.92 0.92 0.92])

% draw bounding rectangle
rectangle('Position', [-2.4, -1.5, 4.3, 2.9]) 

%% FIGURE 5

% get data together:
no_limpets = [treatment_bio_data(1, [6,9,10,14,15,16]);
treatment_bio_data(5, [6,9,10,14,15,16]); treatment_bio_data(9, [6,9,10,14,15,16]);
treatment_bio_data(13, [6,9,10,14,15,16]); treatment_bio_data(17, [6,9,10,14,15,16]);
treatment_bio_data(21, [6,9,10,14,15,16])]; % data for specific morphotypes on ungrazed plates

two_limpets = [treatment_bio_data(8, [6,9,10,14,15,16])];
% data for plates grazed by only 2 limpets

three_limpets = [treatment_bio_data(4, [6,9,10,14,15,16]);
treatment_bio_data(16, [6,9,10,14,15,16]); treatment_bio_data(20, [6,9,10,14,15,16])];
% grazed by three limpets

four_limpets = [treatment_bio_data(3, [6,9,10,14,15,16]);
treatment_bio_data(7, [6,9,10,14,15,16]); treatment_bio_data(11, [6,9,10,14,15,16]);
treatment_bio_data(12, [6,9,10,14,15,16]); treatment_bio_data(15, [6,9,10,14,15,16]);
treatment_bio_data(19, [6,9,10,14,15,16]); treatment_bio_data(23, [6,9,10,14,15,16]);
treatment_bio_data(24, [6,9,10,14,15,16])];
% grazed by four limpets

av_no_limpets = mean(no_limpets);
av_three_limpets = mean(three_limpets);
av_four_limpets = mean(four_limpets);

x = [1:4];
y = [av_no_limpets; two_limpets; av_three_limpets; av_four_limpets;];

% create figure
figure()
h = figure(1)
set(h, 'Position', [230 200 1000 700])

b = bar(x,y) % create bar graph
xlabel('Number of Limpet Grazers', 'FontSize', 12)
ylabel('Average Percent Cover', 'FontSize', 12)
title('Effects of Number of Grazers on Morphotype Abundance', ...
    'FontSize', 14, 'FontWeight', 'bold')

% set bar colors
set(b(1), 'FaceColor', 'k')
set(b(2), 'FaceColor', [0.328,0.328,0.328])
set(b(3), 'FaceColor', [0.6,0.6,0.6])
set(b(4), 'FaceColor', [0.816, 0.816, 0.816])
set(b(5), 'FaceColor', [0.96, 0.96, 0.96])
set(b(6), 'FaceColor', [1,1,1])

% add legend
legend('5 - Filamentous Cyanobacteria', '8 - Diatom', '9 - Diatom', ...
    '13 - Encrusting', '14 - Encrusting', '15 - Coccoidal Cyanobacteria', ...
    'Location', 'NorthEast')

%% FIGURE 6

cn = log(CNratios.CNratio([1:34 59:end]));
groups = {'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', ...
    'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', ...
    'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'C', 'C', 'C', 'C', ...
    'C', 'C', 'C', 'C', 'C', 'C', 'D', 'D', 'D', 'D', 'D', 'D', 'D', ...
    'D', 'D'};
CNratios.LimpetTreat([1:34 59:end]);

figure()
boxplot(cn, groups, 'colors', 'k', 'symbol', '');
xlabel('Treatment', 'FontSize', 12);
ylabel('log(C:N ratio)', 'FontSize', 12);
title('The Effect of Grazing Treatment on C:N Ratio', 'FontSize', 14, ...
    'FontWeight', 'bold')

% add a key
box = text('String', {'A = ungrazed', ...
    ['C = ' '\it L. scabra\rm' '-grazed'], ...
    ['D = ', '\it L. austrodigitalis\rm' '-grazed']}, 'EdgeColor', 'k', ...
    'Position', [2.2, 4.2])

% add lines and stars
line([1.8,3.3], [3.5,3.5], 'Color', 'k')
line([2.6], [3.6], 'Marker', '*', 'MarkerEdgeColor', 'k', 'MarkerSize', 8)
line([1], [2.4], 'Marker', '*', 'MarkerEdgeColor', 'k', 'MarkerSize', 8)
