%% Set parameters
clear;
fc=9e9;c=3e8;
prf=2e3;
T_PRI=1/prf;
B=150e6;        %150 MHz
fs=B;       %sampling rate
Ts=1/B;

M=72;
N_range_cell=M-1;

% Rini=Rc-
N=512;
ratio=1;
La=1;
T_aperture=1;
N_aperture=T_aperture/T_PRI;
lambda=c/fc;
north_south=1;east_west=2;      %determining the direction
direction=1;%can be assigned to a object
vr=150; % first assumption
H=2500;
distance=2500;
R0=sqrt(distance^2+H^2);%direction = 2 or 1
slant_angle=asin(H/R0);
rho_r=c/(2*B*sin(slant_angle));

cell_side=ceil(100/rho_r)*rho_r;
N_azi=round(cell_side/vr/T_PRI);
N_azi=N_azi-mod(N_azi, N_range_cell);
vr=cell_side/N_azi/T_PRI; % actual result
noise_variance=0.01;

% if direction==north_south
%     v=[0;vr;0];
%     UAV_pos_ini=[-distance;0;H];
% else
%     v=[vr;0;0];
%     UAV_pos_ini=[0;distance;H];
% end
p_max=100e4;%1000kw
p_min=1e3;%1kw
p_mean=10e3;
time_slot_max=150;
p_max_total=time_slot_max*p_mean;
save("SARparams.mat")