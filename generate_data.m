%-----------------------------------------------------------------------
% FILE: generate_data.m
% AUTHOR: Benjamin Campbell
% VERSION: 1
% DATE: March 2023
%
% DESCRIPTION: This script was written for SOAR/BISCIT 2023 Control systems
% workshop
%-----------------------------------------------------------------------

% Clear workspace, close figures and command window
clear all 
close all
clc

%% Initialise data collection constants

% Set the highest frequency stimulus
upper_f = 15;

% Set the lowest frequency stimulus
lower_f = 0.01;

% Set the number of frequencies to simulate data for
n = 11;

% List of frequencies to generate data at
test_frequencies = logspace(log10(lower_f), log10(upper_f), n);

%% Run simulations to collect and save data
for i = 1:n
    
    % Display the index of the current frequency
    i
    
    % Set the stimulus frequency
    frequency = test_frequencies(i);   
    
    % Set the simulation run time
    t_run = 1 + 10/frequency;       
    
    % Run the simulation using the Simulink model "fly_gaze_sim.slx"
    sim("fly_gaze_sim.slx");
    
    % Resample the simulation data and store it in a struct
    data.thorax_roll = resample(timeseries(ans.yout{1}.Values.Data, ...
        ans.yout{1}.Values.Time), linspace(1 + 0.2*t_run,t_run,500));
    data.head_roll_intact = resample(timeseries(ans.yout{2}.Values.Data, ...
        ans.yout{2}.Values.Time), linspace(1 + 0.2*t_run,t_run,500));
    data.head_roll_without_halteres = resample(timeseries(ans.yout{3}.Values.Data, ...
        ans.yout{3}.Values.Time), linspace(1 + 0.2*t_run,t_run,500));
    data.frequency = frequency;
    data.run_time = t_run;
    
    % Save the data in a .mat file with a name based on the frequency
    save_name = "Data/gaze_stabilisation_data_" + num2str(round(1000*frequency)) + "mHz";
    save(save_name, "data");
end