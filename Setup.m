% read parameters - these parameters can be read multiple times 
Load_Parameters;

% connecting with function generator and camera
[inst, camera] = Connect_Devices(opt_device);

% default field condition activated
ControlFG(opt_device,1e6,1e6,1.5,1.5);

fprintf('WARNING! POSITIVE DEP WONT BE TERMINATED AUTOMATICALLY')
Remove_Particles(opt_device, camera, thresh, psize);
