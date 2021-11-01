% Austin Berg
% AERO 443
% October 17 2020
% Constraint Diagram
% Script
% Gudmundsson Chapter 3

clear
close all
clc

q = @(rho, V) (1/2)*rho*V^2;

%% Constant Variables
WS = 5:1:200; % Wing Loading vector used in all function calculations (arbitrary)
WS =  WS*47.88;
CDmin = 0.0225; % Gudmundsson, page 62,  business jet CDmin between 0.02 and 0.025
CD_to = 0.0325; % Gudmundsson, page 62,  business jet CDto between 0.03 and 0.035    % Assumes flaps in TO
CL_to = 0.8; % Gudmundsson, page 62,  business jet CLto approximately 0.8   % Assumes flaps in TO
AR = 9;
e = 1.78*(1-0.045*AR^0.68)-0.64;
k = 1/(pi*AR*e);

%% Level Constant Velocity Turn
V.turn = 200/2.24;
h.turn = 20000/3.28;
[~, ~, ~, rho.turn] = atmosisa(h.turn);
q_turn = q(rho.turn, V.turn); % Dynamic Pressure at selected airspeed and altitude (lbf/ft2 or N/m2)
n = 1.4; % load factor, = 1/cos(phi)

[TW_lcvt] = Level_Constant_Velocity_Turn(WS,CDmin, k, q_turn, n);
plot(WS,TW_lcvt);
hold all

%% Desired Climb Rate
V.climb = 200/2.24; % Airspeed
h.climb = 0;
[~, ~, ~, rho.climb] = atmosisa(h.climb);
q_climb = q(rho.climb, V.climb); % Dynamic Pressure at selected airspeed and altitude (lbf/ft2 or N/m2)
Vv = 120/60; % Vertical climb rate speed

[TW_dcr] = Desired_Climb_Rate(WS,Vv, V.climb, q_climb, CDmin, k);
plot(WS,TW_dcr);

%% Desired Takeoff Distance
V.lof = 100/2.24; % Liftoff Speed
h.lof = 0;
[~, ~, ~, rho.lof] = atmosisa(h.lof);
q_to = q(rho.lof, V.lof/sqrt(2)); % Dynamic Pressure at V_lof / sqrt(2) and selected altitude
g = 9.81; % gravity
Sg = 1200/3.28; % ground run
mu = 0.04; % ground coefficient constant

[TW_dtod] = Desired_Takeoff_Distance(WS, V.lof, g, Sg, q_to, CD_to, mu, CL_to);
plot(WS, TW_dtod);

%% Desired Cruise Airspeed
V.cruise = 550/2.24; % Airspeed, ft/s
h.cruise = 38000/3.28;
[~, ~, ~, rho.cruise] = atmosisa(h.cruise);
q_cruise = q(rho.cruise, V.cruise); % dynamic pressure at the selected airspeed and altitude

[TW_dca] = Desired_Cruise_Airspeed(WS, q_cruise, CDmin, k);
plot(WS, TW_dca);

%% Service Ceiling
Vv = 1.667/3.28; % ft/s,  this is if service ceiling is defined as point where climb rate is 100 ft/min, Vertical climb rate speed
h.serv_ceil = 45000/3.28;
[~, ~, ~, rho.serv_ceil] = atmosisa(h.serv_ceil);
rho_sc = rho.serv_ceil;

[TW_sc] = Service_Ceiling(WS, Vv, rho_sc, k, CDmin);
plot(WS, TW_sc);

%% Plot and table
legend("Level Constant-Velocity Turn", ...
    "Desired Climb Rate",... 
    "Desired Takeoff Distance",...
    "Desired Cruise Airspeed",...
    "Service Ceiling");

Constraints = table(WS', TW_dca', TW_dcr', TW_dtod', TW_lcvt', TW_sc');
Constraints.Properties.VariableNames = {'W/S','Desired Cruise Altititude','Desired Climb Rate','Desired Takeoff Distance','Level Constant-Velocity Turn', 'Service Ceiling'};
disp(Constraints);

disp('Altitudes (m)');
disp('1 m = 3.28 ft');
disp(h);
fprintf('\n');

disp('Speeds (m/s)');
disp('1 m/s = 2.24 mph');
disp(V);




