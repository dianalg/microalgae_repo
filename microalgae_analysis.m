% microalgae_analysis.m

% Takes averaged photoquad data and averaged by groups photoquad data in
% addition to environmental data (from Luke Miller's field work, 2013) and
% compares the biological aspects of the imaged biolfilms with
% environmental factors (temperature and fluorescence).

% Inputs:

% Averaged_Photoquad_Data.csv - contains % cover data for biofilm samples
% averaged by treatment.

% Averaged_by_groups.csv - contains % cover data for biofilm samples when
% morphotypes are grouped into filamentaous cyanobacteria, diatoms, etc.

% Environmental_Data.csv - contains environmental data from Luke Miller's
% field work in December 2013.  The second column is fluorescence, the
% third is the temperature range experienced by the treatment, and the
% fourth is the maximum temperature experienced by the treatment [C].

% Output:

% Graphs for analysis.

clear
clc

%% LOAD FILES

drive = 'C:\Users\Diana\Documents\work\Stanford\Microalgae\Data\'; % Ender

filename1 = [drive 'Averaged_Photoquad_Data_MATLAB.csv'];
filename2 = [drive 'Averaged_by_groups_MATLAB.csv'];
filename3 = [drive 'Environmental_Data.csv'];

treatment_bio_data = load(filename1);
group_bio_data = load(filename2);
enviro_data = load(filename3);

%% ANOVA COMPARISONS

treatment = {'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', ...
    'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D'};

disp('Effect of grazing on F0') % ----------------------------------------

[p, t, stats] = anova1(enviro_data(:,2), treatment); % prints ANOVA table 
% and associated plot
title('Effect of grazing on F0')
xlabel('Grazing Treatment')
ylabel('F0, December 2013')

figure()
[c,m] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test
% and displays the following:
    % c = tukey's comparison table, column names = ['group 1', 'group 2
    % that is being compared to group 1', 'lower 95% confidence threshold
    % for the mean of group 1 minus the mean of group 2', 'mean of group 1
    % minus the mean of group 2', 'upper 95% confidence threshold for the
    % mean of group 1 minus the mean of group 2', 'p-value']
    % m = list of means and standard error estimates

disp('Checking that temperature is not connected with treatment...')% ----

[p, t, stats] = anova1(enviro_data(:,3), treatment); 
title('Checking for any relationship between temperature and grazing')
xlabel('Grazing Treatment')
ylabel('Daily temp interval [C], December 2013')

[p, t, stats] = anova1(enviro_data(:,4), treatment); 
title('Checking for any relationship between temperature and grazing')
xlabel('Grazing Treatment')
ylabel('Daily max temp [C], December 2013')

% Next, I'll check relationships between %cover and F0, focusing on
% morphotypes 13, 14, 5 and 10 for treatment_bio_data and on all groups
% except non-biological for grouped_bio_data.

disp('Connections between %cover and F0') % ------------------------------

disp('Morphotype 5')

[p, t, stats] = anova1(treatment_bio_data(:,6), treatment);
title('Effect of grazing on Presence of Morphotype 5 (Noodles)')
xlabel('Grazing Treatment')
ylabel('%cover Morphotype 5')

disp('Morphotype 10')

[p, t, stats] = anova1(treatment_bio_data(:,11), treatment);
title('Effect of grazing on Presence of Morphotype 10 (Rod-shaped diatoms)')
xlabel('Grazing Treatment')
ylabel('%cover Morphotype 10')

disp('Morphotype 13')

[p, t, stats] = anova1(treatment_bio_data(:,14), treatment);
title('Effect of grazing on Presence of Morphotype 13 (Encrusting)')
xlabel('Grazing Treatment')
ylabel('%cover Morphotype 13')

disp('Morphotype 14')

[p, t, stats] = anova1(treatment_bio_data(:,15), treatment);
title('Effect of grazing on Presence of Morphotype 14 (Honeycomb)')
xlabel('Grazing Treatment')
ylabel('%cover Morphotype 14')

figure()
[c,m] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test

disp('Filamentous Cyanobacteria')

[p, t, stats] = anova1(group_bio_data(:,2), treatment);
title('Effect of grazing on Presence of Filamentous Cyanobacteria')
xlabel('Grazing Treatment')
ylabel('%cover Filamentous Cyanobacteria')

disp('Diatoms')

[p, t, stats] = anova1(group_bio_data(:,3), treatment);
title('Effect of grazing on Presence of Diatoms')
xlabel('Grazing Treatment')
ylabel('%cover Diatoms')

figure()
[c,m] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test

disp('Encrusting')

[p, t, stats] = anova1(group_bio_data(:,4), treatment);
title('Effect of grazing on Presence of Encrusting Biofilm')
xlabel('Grazing Treatment')
ylabel('%cover Encrusting Biofilm')

figure()
[c,m] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test

disp('Coccoidal Cyanobacteria')

[p, t, stats] = anova1(group_bio_data(:,5), treatment);
title('Effect of grazing on Presence of Coccoidal Cyanobacteria')
xlabel('Grazing Treatment')
ylabel('%cover Coccoidal Cyanobacteria')

disp('Check for interactions between F0, temp and %cover') % ------------

disp('Relationship between F0 and max temp')
% there should be a negative correlation between F0 and max temp

mdl = fitlm(enviro_data(:,4), enviro_data(:,2))
% fit a linear model

figure()
scatter(enviro_data(:,4), enviro_data(:,2))
% can visualize the model using the basic fitting tool
title('Relationship between max temp and F0')
xlabel('Maximum Temperature [C]')
ylabel('Fluorescence F0')

xdata = enviro_data(:,4); % temp data
xA = [xdata(1), xdata(5), xdata(9), xdata(13)];
xB = [xdata(2), xdata(6), xdata(10), xdata(14)];
xC = [xdata(3), xdata(7), xdata(11), xdata(15)];
xD = [xdata(4), xdata(8), xdata(12), xdata(16)];

ydata = enviro_data(:,2); % F0 data

yA = [ydata(1), ydata(5), ydata(9), ydata(13)];
yB = [ydata(2), ydata(6), ydata(10), ydata(14)];
yC = [ydata(3), ydata(7), ydata(11), ydata(15)];
yD = [ydata(4), ydata(8), ydata(12), ydata(16)];

p = polyfit(xA, yA, 1); % returns the slope and intercept of linear fit
fit_yA = p(1)*xA + p(2); % calculates predicted y-values based on linear 
% model
p2 = polyfit(xB, yB, 1);
fit_yB = p2(1)*xB + p2(2); 
p3 = polyfit(xC, yC, 1);
fit_yC = p3(1)*xC + p3(2); 
p4 = polyfit(xD, yD, 1);
fit_yD = p4(1)*xD + p4(2); 

figure()
hold on
scatter(xA, yA, 'g')
plot(xA, fit_yA, 'g')
scatter(xB, yB, 'c')
plot(xB, fit_yB, 'c')
scatter(xC, yC, 'm')
plot(xC, fit_yC, 'm')
scatter(xD, yD, 'b')
plot(xD, fit_yD, 'b')
title('Effects of temperature and grazing on F0')
xlabel('Max Temp [C]')
ylabel('F0')
legend('Ungrazed', 'Linear Fit A', 'Community Grazed', 'Linear Fit B', ...
    'L. scabra', 'Linear Fit C', 'L. austrodigitalis', 'Linear FIt D')
hold off

aoctool(xdata, ydata, treatment, 0.05)
% Performs an ANCOVA test  - results seem to indicate no interaction
% between temperature and treatment









