classdef Multiple_UAV_Solver < Single_UAV_Solver
    % 注意是繼承Single_UAV_Solver
    % 被註解掉的property是因為只能定義一次
    % 被註解掉的method則是因為一模一樣，不用改
    properties
        % basic parameters for SAR and OFDM waveform
        % all these parameters will be set in constructor
%         fs;
%         fc;
%         c;
%         prf;
%         B;
%         pri;
%         Ts;
%         M;
%         N_range_cell;
%         T_aperture;
%         N_aperture;
%         lambda;
%         vr;
%         H;
%         distance;
%         R0;
%         slant_angle;
%         rho_r;
%         cell_side;
%         N_azi;
%         ratio;
%         La;
%         N;

        % parameters for power optimization
%         p_max;
%         p_min;
%         p_mean;
%         p_max_total;
%         power_initial_vec;

        % parameters for path planning
%         time_slot_max;
%         start;
%         sensing_matrix;
%         sensing_matrix_2;
%         obstacle_matrix;
%         turn_cost_right;
%         turn_cost_left;
%         noise_variance;

        % parameters for path planning (set in build_cells)
%         mean_rate;
%         cell_matrix;
%         all_rate_matrix;
%         coef_vec_cell_matrix; % the channel coeficients for each cell
%         N_max_user;
%         N_user_matrix;

        % parameters for build cell
%         N_cell_x;
%         N_cell_y;
        
        
        % algorithms (path solvers)
%         Solver_row; % default path solver is DP
%         N_Solver; % number of algorithms
        N_UAV;
        alpha_multiplier;
    
        % unused parameters
%         total_users;
        % Solvers (Solver row is for origninal DP)
        DP_comm_multi_Solver;
        DP_sens_multi_Solver;

        
    end
    methods
        build_cells(obj);
%         set_cells(obj, cell_matrix)
%         set_sensing_matrix(obj, sensing_matrix, sensing_matrix_2);
        initialize_DP_multi_Solver(obj)
        initialize_DP_comm_multi_Solver(obj)
        initialize_DP_sens_multi_Solver(obj)
        function obj=Multiple_UAV_Solver() % constructor
            obj.N_UAV=3;
            obj.fc=9e9;
            obj.c=3e8;
            obj.prf=2e3;
            obj.pri=1/obj.prf;
            obj.B=150e6;        %150 MHz
            obj.fs=obj.B;       %sampling rate
            obj.Ts=1/obj.B;
            
            obj.M=72;
            obj.N_range_cell=obj.M-1;
            
            % Rini=Rc-
            obj.N=512;
            obj.ratio=1;
            obj.La=1;
            obj.T_aperture=1;
            obj.N_aperture=obj.T_aperture/obj.pri;
            obj.lambda=obj.c/obj.fc;
            obj.vr=150; % first assumption
            obj.H=2500;
            obj.distance=2500;
            obj.R0=sqrt(obj.distance^2+obj.H^2);%direction = 2 or 1
            obj.slant_angle=asin(obj.H/obj.R0);
            obj.rho_r= obj.c/(2*obj.B*sin(obj.slant_angle));
            obj.cell_side=ceil(100/obj.rho_r)*obj.rho_r;
            obj.N_azi=round(obj.cell_side/obj.vr/obj.pri);
            obj.N_azi= obj.N_azi-mod(obj.N_azi, obj.N_range_cell);
            obj.vr= obj.cell_side/ obj.N_azi/ obj.pri; % actual result
            obj.time_slot_max=70;
            % if direction==north_south
            %     v=[0;vr;0];
            %     UAV_pos_ini=[-distance;0;H];
            % else
            %     v=[vr;0;0];
            %     UAV_pos_ini=[0;distance;H];
            % end
            obj.p_max=100e4;%1000kw
            obj.p_min=1e3;%1kw
            obj.p_mean=10e3;
            obj.p_max_total= obj.time_slot_max* obj.p_mean;
            obj.power_initial_vec=ones(1, obj.time_slot_max)*obj.p_mean;

            obj.N_cell_x=10;
            obj.N_cell_y=10;

            obj.start=[5;5];
            obj.sensing_matrix=ones(obj.N_cell_x, obj.N_cell_y);
            obj.sensing_matrix_2=ones(obj.N_cell_x, obj.N_cell_y);
            obj.obstacle_matrix=zeros(obj.N_cell_x, obj.N_cell_y);
            obj.turn_cost_left=13;
            obj.turn_cost_right=9;
            obj.noise_variance=0.01;

            if isempty(obj.cell_matrix)
                obj.build_cells();
            end
            obj.initialize_DP_multi_Solver();


            % parameters not yet decided

        end
        
        
    end
end