clear all;tic;
%% Set parameters
fc=9e9;c=3e8;
prf=2e3;
T_PRI=1/prf;
B=150e6;        %150 MHz
fs=B;       %sampling rate
Ts=1/B;
M=96;
N_range_cell=M-1;

% Rini=Rc-
N=512;
ratio=1;
La=1;
T_aperture=1;
N_aperture=T_aperture/T_PRI;
lambda=c/fc;
north_south=1;east_west=2;      %determining the direction

vr=150;
H=3000;
distance=3000;

R0=sqrt(distance^2+H^2);%direction = 2 or 1
slant_angle=asin(H/R0);
%%
all_step=[5, 5;
          5, 6];
% UAV_start_end=[-1600, -1600, -1550, -1550]
load('cell_matrix.mat',"N_cell_y", "N_cell_x","time_slot_max",  "cell_matrix", "start");
cell_side=100;
UAV_start_end=get_start_end(all_step, cell_matrix, distance, cell_side);
%%
ii=1;
x1=all_step(1, ii);
x2=all_step(1,ii+1);
y1=all_step(2, ii);
y2=all_step(2, ii+1);

if x1-x2==1
    direction=2;
elseif x2-x1==1
    direction=0;
elseif y1-y2==1
    direction=3;
elseif y2-y1==1
    direction=1;
else
    disp('error diagonal');
    % disp('er1');
    disp(num2str(x1));
    disp(num2str(y1));
    disp(num2str(x2));
    disp(num2str(y2));
end
if direction==1||direction==3
    v=[0;vr;0];
    UAV_pos_ini=[-distance;-0;H];

else
    v=[vr;0;0];
    UAV_pos_ini=[-0;distance;H];
end

%% generate transmitted sequence
PN=comm.PNSequence('SamplesPerFrame',N);
S=PN()*2-1;% N by 1
s=zeros(N,1);
k=(0:N-1).';
for ii=0:N-1
    exp_vec=exp(1j*2*pi*k*ii/N);
    s(ii+1)=sum(S.*exp_vec);% ii+1 to map 0:N-1 to array indices 1:N 
end
s=s/sqrt(N);
s_CP=[s(end-(M-2):end);s]; %add CP with length M-1 
% The above is equal to ifft(S)*sqrt(N)
% plot(0:N-1, imag(s), 'o')
% hold on
% plot(0:N-1, imag(ifft(S))*sqrt(N))
% legend('s','S')
% Note that the symbol time is also the sampling period 
%%
N_azi=round(cell_side/vr/T_PRI);%go 100 m
range_axis_size=round(T_PRI/Ts);
azimuth_axis_size=N_azi;
received_signal=zeros(range_axis_size, azimuth_axis_size);
front_array=zeros(N_azi, 1);

% UAV_start=UAV_start_end(:,ii*2-1);
% UAV_end=UAV_start_end(:,ii*2);
% if abs(UAV_start(1)-UAV_end(1))==cell_side
%     pos_array=linspace(UAV_start(1), UAV_end(1), N_azi);
%     UAV_pos_array_old=[pos_array;ones(1, N_azi)*UAV_end(2);ones(1, N_azi)*H];
% else
%     pos_array=linspace(UAV_start(2), UAV_end(2), N_azi);
%     UAV_pos_array_old=[ones(1, N_azi)*UAV_end(1);pos_array;ones(1, N_azi)*H];
% end
% front_first_scatter=zeros(N_azi, 1);
% rho_r=c/(2*B*sin(slant_angle));
%% Generate point scatters
% N_points=N_range_cell*2;
N_points=16;
rho_r=c/(2*B*sin(slant_angle));
points=zeros(3, N_points);
reference_point=[cell_side/2;cell_side/2;0];

points(:, 1)=[0;0;0];
points(:, 2)=[1;0;0];
points(:, 3)=[-1 ;0;0];
points(:, 4)=[0;1;0];
points(:, 5)=[1;1;0];
points(:, 6)=[-1 ;1;0];
points(:, 7)=[0;-1;0];
points(:, 8)=[1;-1;0];
points(:, 9)=[-1 ;-1;0];
points(:, 10)=[2;1;0];
points(:, 11)=[2;0;0];
points(:, 12)=[2;-1;0];
points(:, 13)=[1;2;0];
points(:, 14)=[0;2;0];
points(:, 15)=[-1;2;0];
points(:, 16)=[2;2;0];
% points=points*rho_r;


% points(:, 1)=[0;10;0];
% points(:, 2)=[30*rho_r;20;0];
% y_fixed=-40;
% closest_approach=[0*rho_r; 0; 0];         %assuming M is even
% for ii=1:N_points
% %     points(:, ii)=[(30+mod(ii-1,5))*rho_r;(ceil(ii/5)-1)*rho_r;0];
%     points(:, ii)=[(ii-1)*rho_r;15;0];
% end
% rho_r=rho_r*0.99;
% for ii=1:N_points
% %     points(:, ii)=[(30+mod(ii-1,5))*rho_r;(ceil(ii/5)-1)*rho_r;0];
%     if ii<=N_points/2
%         points(:, ii)=[(ii-1)*rho_r;0;0]+first_scatterer;
%     else
%         points(:,ii)=[(ii-floor(N_points/2)-1)*rho_r;rho_r*2;0]+first_scatterer;
%     end
% end
for ii=1:N_points
    % points(:, ii)=[(30+mod(ii-1,5))*rho_r;(ceil(ii/5)-1)*rho_r;0]+middle_point-[cell_side/2;0;0];
%     points(:, ii)=[(ii-1)*rho_r;0;0]+middle_point-[cell_side/2;0;0];
    % points(:,ii)=[(ii-floor(N_points/2)-1)*rho_r;rho_r*2;0]+first_scatterer;
    points(:, ii)=points(:, ii)+reference_point;
end



%% Imaging start
L=size(s_CP,1);%   613=512+102-1
rest=range_axis_size-L;   %calculate the total number of samples minus the data length
R=zeros(N_points, N_azi);
% R_row=zeros(1,N_azi);
aperture_filter=zeros(1, N_azi);
aperture_radius=150/2;%can be changed in the future
index=1:N_azi;
UAV_pos_array_original=UAV_pos_ini+v*index*T_PRI;
UAV_pos_array=UAV_pos_array_original;
%%
% signal_all=zeros(N+M-1, N_azi, N_points);

%first scatter for range imaging
first_scatterer=[0;cell_side/2;0];
R_row=vecnorm(UAV_pos_array-first_scatterer);
R_row=into_fixpoint(R_row);
Rc=min(R_row);
Rc_delay=2*Rc/c/Ts;
fraction=Rc_delay-floor(Rc_delay);
t_start=fraction*Ts;                            %start sampling at this time to align with the first range cell
front=round((2*Rc/c-t_start)/Ts);
front_array_first_scatter=ones(N_azi,1)*front;

%% For each point generate received signal
for ii=1:N_points

    scatter=points(:, ii);
    R_row=vecnorm(UAV_pos_array-scatter);
    R_row_origin=R_row;
    R_row=into_fixpoint(R_row);
    R_row=into_discrete(R_row, 100e-6, T_PRI, cell_side/vr);
    R(ii,:)=R_row;

    Rc=min(R_row);
    Rc_delay=2*Rc/c/Ts;
    fraction=Rc_delay-floor(Rc_delay);
    t_start=fraction*Ts;                            % start sampling at this time to align with the first range cell
    front=round((2*Rc/c-t_start)/Ts);
    front_array=ones(N_azi,1)*front;                % all aligned at front (closest distance of UAV)
%     zero_padding=rest-front;
    if direction==north_south
        aperture_filter=(UAV_pos_array(2,:)<scatter(2)+aperture_radius)&(UAV_pos_array(2,:)>scatter(2)-aperture_radius);
    else
        aperture_filter=(UAV_pos_array(1,:)<scatter(1)+aperture_radius)&(UAV_pos_array(1,:)>scatter(1)-aperture_radius);
    end
    phase=single(4*pi*fc*R_row_origin/c);
    phase=into_discrete(phase, 100e-6, T_PRI, cell_side/vr);
    sample=exp(-1j*phase).*aperture_filter;
    signal=s_CP*sample;     %(N+M-1)*N_azi
    received_signal(front+1:front+L, :)=received_signal(front+1:front+L, :)+signal; % Do RCMC directly(all delay are the same)
    % signal_all for old section
    % signal_all(:,:,ii)=s_CP*sample;%(N+M-1)*N_azi

end
% vecnorm(points).';



%% check front array
error2=0;
if (sum(front_array==front_array(1))~=length(front_array))
    error2=1;
end
%% Assuming all front are the same (No RCMC)
% Do range compression
front=front_array_first_scatter(1);
range_data=received_signal(front+1+M-1:front+L, :);%removing first M-1 samples
range_data_FT=fft(range_data);
S_back=(fft(s_CP(M:end))); %excluding cp
D_hat=range_data_FT./S_back;
d_hat=(ifft(D_hat));
d_hat_zero=[d_hat;zeros(2*M-2, N_azi)];

d_hat_zero_azi_FT=fft(d_hat_zero.');%transpose for azimuth direction fft
d_hat_zero_azi_FT=fftshift(d_hat_zero_azi_FT,1);

% Rc_array=R0+(1:N+2*M-2)*rho_r;
% Ka_array=2*fc*vr^2/c./Rc_array;
% fl=(index/N_azi/T_PRI).';
% RCMC_row=lambda^2*Rc_array/8/vr^2;
% exp_matrix=exp(1j*(fl.^3*RCMC_row)*4*pi/c);
% exp_matrix=ones(N+2*M-2,length(index)).';
% H_az_array=exp(-1j*pi*(fl).^2/Ka); is the goal
% Ka_array=(1./Ka_array);
% H_az_array=exp(-1j*pi*(fl).^2*Ka_array).*exp_matrix;

% d_hat_zero_azi_FT=d_hat_zero_azi_FT.*H_az_array;
d_hat_zero_azi_FT=fftshift(d_hat_zero_azi_FT,1);
d_hat_zero=ifft(d_hat_zero_azi_FT).';

received_signal(front+1:front+N+2*M-2,:)=d_hat_zero;



%%
% plot(1:512, abs(received_signal(front+1:front+512, 1200)))
%%
index=((1:N_azi)-round(N_azi/2))+1;
fl_old=(index/N_azi/T_PRI).';
R0_array=R0+(1:M)*rho_r;
Ka=2*fc*vr^2/c./R0_array;
one_over_Ka=1./Ka;
H_az=exp(-1j*pi*(fl_old).^2*one_over_Ka);
received_signal_FT=fft(received_signal.'); % column for fft (fft on row)
received_signal_FT=fftshift(received_signal_FT, 1);
received_signal_FT(:,front+1:front+M)=received_signal_FT(:,front+1:front+M).*H_az;% H_az was a row, multiply column => each column do .*
received_signal_FT=fftshift(received_signal_FT,1);
received_signal=ifft(received_signal_FT).';






%% Check if all samples are aligned
error_result=zeros(1,N_range_cell-1);
first_scatterer=[0;0;0]; 
for i=1:N_range_cell-1
    second_scatterer=[i*rho_r;0;0];               %locate at the ith range cell
    R_first=min(vecnorm(UAV_pos_array-first_scatterer));
    R1=min(vecnorm(UAV_pos_array-second_scatterer));
%     n1=2*R1/c/Ts-floor(2*R1/c/Ts);
%     t_start=n1*Ts;         %start sampling at this time to align with the first range cell
    error_result(i)=round( (2*R1/c-t_start)/Ts )-round( (2*R_first/c-t_start)/Ts );
end
error=0;
if sum(abs(error_result-(1:N_range_cell-1)))~=0
    error=1;
end
%% Check if there are overlapping range cells
error3=0;
error4=0;
for i=1:N_range_cell-1-1
    if error_result(i+1)==error_result(i)
        error3=1;
    end
end
if max(error_result)>M
    error4=1;
end

%%
toc;
%%
% plot(1:N_iter, front_array)
figure();
x_lim=[1, N_azi];
y_lim=[front+1, front+N_range_cell];% N_range_cell points
azi_lim=x_lim*vr*T_PRI;
% range_lim=y_lim*Ts*c/2/sin(slant_angle);
% range_lim=y_lim*rho_r;
range_lim=[R0, R0+N_range_cell*rho_r];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%需要驗算

% C=abs(received_signal(:,:));
C=abs(received_signal(y_lim(1):y_lim(2),x_lim(1):x_lim(2)));
x=linspace(azi_lim(1),azi_lim(2),x_lim(2)-x_lim(1)+1);
y=linspace(range_lim(1),range_lim(2),y_lim(2)-y_lim(1)+1);
imagesc(x,y,C)
ylabel 'range(m)'
xlabel 'azimuth(m)'
% imagesc(C)
% plot(1:N_iter, abs(received_signal(9900, :)))
% C_new=zeros(N_range_cell, N_range_cell);
% batch_size=round(N_azi/N_range_cell);
% for ii=1:N_range_cell
%     C_cols=C(:, 14*(ii-1)+1:14*ii);
%     C_new(:, ii)=...
%         ones(size(C,1),1).*mean(C_cols,2);
% end
% y=linspace(range_lim(1),range_lim(2),N_range_cell);
% figure();
% imagesc(x,y,C_new)


