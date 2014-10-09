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
[p_vals, means] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test
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

% disp('Morphotype 5')
% 
% [p, t, stats] = anova1(treatment_bio_data(:,6), treatment);
% title('Effect of grazing on Presence of Morphotype 5 (Noodles)')
% xlabel('Grazing Treatment')
% ylabel('%cover Morphotype 5')
% 
% disp('Morphotype 10')
% 
% [p, t, stats] = anova1(treatment_bio_data(:,11), treatment);
% title('Effect of grazing on Presence of Morphotype 10 (Rod-shaped diatoms)')
% xlabel('Grazing Treatment')
% ylabel('%cover Morphotype 10')
% 
% disp('Morphotype 13')
% 
% [p, t, stats] = anova1(treatment_bio_data(:,14), treatment);
% title('Effect of grazing on Presence of Morphotype 13 (Encrusting)')
% xlabel('Grazing Treatment')
% ylabel('%cover Morphotype 13')

disp('Morphotype 14')

[p, t, stats] = anova1(treatment_bio_data(:,15), treatment);
title('Effect of grazing on Presence of Morphotype 14 (Honeycomb)')
xlabel('Grazing Treatment')
ylabel('%cover Morphotype 14')

figure()
[p_vals, means] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test

% disp('Filamentous Cyanobacteria')
% 
% [p, t, stats] = anova1(group_bio_data(:,2), treatment);
% title('Effect of grazing on Presence of Filamentous Cyanobacteria')
% xlabel('Grazing Treatment')
% ylabel('%cover Filamentous Cyanobacteria')

disp('Diatoms')

[p, t, stats] = anova1(group_bio_data(:,3), treatment);
title('Effect of grazing on Presence of Diatoms')
xlabel('Grazing Treatment')
ylabel('%cover Diatoms')

figure()
[p_vals, means] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test

disp('Encrusting')

[p, t, stats] = anova1(group_bio_data(:,4), treatment);
title('Effect of grazing on Presence of Encrusting Biofilm')
xlabel('Grazing Treatment')
ylabel('%cover Encrusting Biofilm')

figure()
[p_vals, means] = multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test

% disp('Coccoidal Cyanobacteria')
% 
% [p, t, stats] = anova1(group_bio_data(:,5), treatment);
% title('Effect of grazing on Presence of Coccoidal Cyanobacteria')
% xlabel('Grazing Treatment')
% ylabel('%cover Coccoidal Cyanobacteria')

disp('Check for interactions between F0, temp and %cover') % ------------

disp('Relationship between F0 and max temp')
% there should be a negative correlation between F0 and max temp

mdl = fitlm(enviro_data(:,4), enviro_data(:,2));
% fit a linear model

figure()
scatter(enviro_data(:,4), enviro_data(:,2))
% can visualize the model using the basic fitting tool
title('Relationship between max temp and F0')
xlabel('Maximum Temperature [C]')
ylabel('Fluorescence F0')

%% ANCOVA TESTS

xdata = enviro_data(:,4); % temp data
ydata = enviro_data(:,2); % F0 data

disp('ANCOVA test looking at F0, temperature and treatment') % -----------

[h, atab, ctab, stats] = aoctool(xdata, ydata, treatment, 0.05);
% Performs an ANCOVA test  - results seem to indicate an interaction
% between temperature and treatment A

figure()
multcompare(stats, 'ctype', 'hsd') % calculates Tukey's test

% disp('ANCOVA test looking at F0, filamentous cyanobacteria and treatment') 
% 
% [h, atab, ctab, stats] = aoctool(group_bio_data(:,2), ydata, treatment, ...
%     0.05); % ANCOVA
% 
% disp('ANCOVA test looking at F0, diatoms and treatment') % ---------------
% 
% [h, atab, ctab, stats] = aoctool(group_bio_data(:,3), ydata, treatment, ...
%     0.05); % ANCOVA
% 
% disp('ANCOVA test looking at F0, encrusting biofilm and treatment') % ----
% 
% [h, atab, ctab, stats] = aoctool(group_bio_data(:,4), ydata, treatment, ...
%     0.05); % ANCOVA
% 
% disp('ANCOVA test looking at F0, cocoidal cyanobacteria and treatment') 
% 
% [h, atab, ctab, stats] = aoctool(group_bio_data(:,5), ydata, treatment, ...
%     0.05); % ANCOVA

disp('ANCOVA test looking at temp, filamentous cyanobacteria and treatment') 

[h, atab, ctab, stats] = aoctool(xdata, group_bio_data(:,2), treatment, ...
    0.05); % ANCOVA
figure()
multcompare(stats, 'ctype', 'hsd')

% disp('ANCOVA test looking at temp, diatoms and treatment') % -------------
% 
% [h, atab, ctab, stats] = aoctool(xdata, group_bio_data(:,3), treatment, ...
%     0.05); % ANCOVA
% 
% disp('ANCOVA test looking at temp, encrusting biofilm and treatment') % --
% 
% [h, atab, ctab, stats] = aoctool(xdata, group_bio_data(:,4), treatment, ...
%     0.05); % ANCOVA
% 
% disp('ANCOVA test looking at temp, cocoidal cyanobacteria and treatment') 
% 
% [h, atab, ctab, stats] = aoctool(xdata, group_bio_data(:,5), treatment, ...
%     0.05); % ANCOVA

%% COMPARE WITH LIMPET GROWTH DATA

%% COMPARE WITH RADULA SIZE


