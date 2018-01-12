set(0,'DefaultFigureWindowStyle','docked')

% adjustable parameters
obj = 63;       % Objective magnification
mag = 1.2;     % Magnifier factor
bin = 4;        % Camera binning (1, 2, 4, or 8)

diam = 2340;        % Particle diameter, nm
opt_device = 1; % 1: single channel; 2: double channel
psize = 5;      % Size of particle in pixels, must be an odd number
thresh = 220;    % Threshold cutoff
Total_Cycle = 5;  % number of cycles to be conducted
Assembly_Time = 500; % assebmly time of each cycle
Quench_Period = 50; % (optional) initial isotropic quench time
Disassemble_Time = 100; % liquidify time
Epoch = 100; % control period time

Psi6scale = 0.82; % correction factor of Psi6 due to image noises
C6scale = 0.95; % correction factor of C6 due to image noises
final_Thresh = 0.90; % criterion of psi6 for perfect crystal
dilute_thresh = 23000; % criterion of Rg for liquid state (32500)
isoquench_thresh = 0.8;

% constant parameters
scale = 1214*(bin/8)*(40/obj)*(1/mag);      % Pixel scale
fwidth = 1344/bin;      % Frame width
fheight = 1024/bin;     % Frame height
corrector = 0.95;       % Correction factor if particles are being squeezed too tightly
pex=23;         %Exclude particles greater than pex*aeff
kappa_inv = 30;     % Debye length, nm
x_Debye = 2;        % Number of Debye lengths (2 for 0.1mM, 6 for 1mM)
aeff = (diam/2) + (x_Debye*kappa_inv);  % Effective particle radius, nm 
crad = aeff;        % Coordination radus, nm
ctestv = 0.32;      % Critical test value for order parameter acceptance
TCF = 0.92;         % Thermal correction factor
dh = (1+sqrt(3))*crad;  % Upper coordination radius bound, nm
dl = crad*TCF;      % Lower bound for coordination radius, nm

a0 = 7.15+((4.1*10^-3)*kappa_inv);
b0 = -0.219-((4.24*10^-4)*kappa_inv);
Voltage = a0*(300^(b0));

% Stop camera
% stoppreview(vid)
% stop(vid)
% delete(vid)
% clear vid
% %%%%%%%%%%%%%%%%%%%%%%
% % close usb connections
% fclose(inst)
% delete(inst)
% clear inst
