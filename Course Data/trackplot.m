%% ==============================
% Track Plotting Script
% ===============================

clear; clc; close all;

%% ---- Load .mat file ----
% Replace 'trackdata.mat' with your file name
dataStruct = load('Endurance_2024_Refined.mat');

% If the .mat file contains one variable, extract it automatically:
fld = fieldnames(dataStruct);
track = dataStruct.(fld{1});

% track must be N x 7
% Columns:
% 1 = X coordinate of track
% 2 = Y coordinate of track
% 3 = Radius of curvature
% 4 = Segment length
% 5 = Cumulative length
% 6 = X of center of curvature circle
% 7 = Y of center of curvature circle

X = track(:,1);
Y = track(:,2);
R = track(:,3);        % radius of curvature
segLen = track(:,4);
cumLen = track(:,5);
cx = track(:,6);       % center X
cy = track(:,7);       % center Y

%% ---- Choose a color variable for plotting ----
C = R;     % color by radius of curvature (change as needed)

X = track(:,1);
Y = track(:,2);

%% ---- Plot the track ----
figure; hold on;

plot(X, Y, 'w-', 'LineWidth', 2);    % solid black line

axis equal;
xlabel('X (m)');
ylabel('Y (m)');
title('Track Plot');

grid on;
hold off;