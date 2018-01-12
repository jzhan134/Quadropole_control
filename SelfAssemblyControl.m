%{
This code is used to control 300 particle self-assembly experiment. It connects to the microscope
camera. which captures images of particles, and the function generator, which generate the electric
field according to specification.
    
For camera control and image processing, the code provides interface with the camera and could set
the camera specification; the code also identifies the particle coordinates in each frame, and
calculate the order parameters from the coordinates

For function generator control, the code could manually or automatically pick the field conditions
for (1) isotropic field and (2) anisotropic field. Isotropic field is generated from a single
channel function generator and connected to a quadropole, where opposite poles are connected with
same polarity. The frequency and amplitude are controlled, which affect the direction and magnitude
of the field respectively. Anisotropic field is generated from a double channel function generator
and connected to two pairs of quadropoles, where each pair of poles are positioned on a rectangular
edge, and the two paires are orthorgonal to each other. Same parameters are controlled by each pair
of field individually.

The control algorithm provides different mechanisms for each type of field. In all of the following 
cases, the control starts with a relax period, where a minimal amount of field is applied to relax
particles from the previous cycle of experiment. After the self-assembly experiment, the cycle is
terminated when a perfect crystal is detected or when time is up. The types of mechanisms are:
1. isotropic quench:    field is turned on and off alternatively at a fixed frequency 
2. anisotropic quench:  two orthogonal fields are activated alternatively at a fixed frequency 
3. anisotropic control: two orthogonal fields are chosen based on the image analysis result.
                        Specifically, the file whose long axis is most algin to the orientation of
                        the grain boundary is activated

List of all functions:
[inst, camera] = Connect_Devices(opt_device);
      input: 
          opt_device: index representing the type of function generator
      output:
          inst:       visa file for function generator
          camera:     videoinput object


Remove_Particles(opt_device, camera, pControl, pImage);
      input:
          opt_device: index representing the type of function generator
          camera:     videoinput object
          pControl:   parameter structure used to choose voltage
          pImage:     parameter structure used to calculate particle coordinates


[Rg, Psi6, C6] = Status_Update(camera, pImage, pOP, Ctrl_Opt, Frame, fps);
      input: 
          camera:     videoinput object
          pImage:     parameter structure used to calculate particle coordinates
          pOP:        order parameter structure used to calculate and correct order parameters
          Ctrl_Opt:   index of the field used in the current frame
          Frame:      number of current frame
          fps:        frame rate for current stage experiment
      output:
          Rg:         before deviding by 1000
          Psi6:       corrected by noises
          C6:       corrected by noises

%}

% initialize all parameters and establish connection to function generator and camera
Load_Parameters;
[inst, camera] = Connect_Devices(opt_device);

% Remove extra particles from the field to limit the total number to 300
Remove_Particles(opt_device, camera, thresh, psize);


file_name = ''; % data save path
Succ = 0; % counter of success cycles
for cycle = 1:Total_Cycle
    
    % create new files for each cycle
    Tiff_File = sprintf('%s\Cycle_%d.tif',file_name,cycle);
    OP_File = sprintf('%s/Cycle_%d_OP.mat',file_name,cycle);
    Coordinate_File = sprintf('%s/Cycle_%d_Coord.mat',file_name,cycle);

    % disassemble stage - fix at the smallest field until liquid state or maximum time reached
    ControlFG(opt_device,1e6,0,Voltage*0.1,Voltage*0.1);
    [Rg, Psi6, C6] = Status_Update(camera, pImage, pOP, 0, 0, 1);
    tic;
    
    % update status every second
    for t = 1:Disassemble_Time
        pause(t - toc);
        [Rg, Psi6, C6] = Status_Update(camera, pImage, pOP, 0, 1, 1);
        if (Rg >= dilute_thresh)
            break;
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Isotropic field %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if opt_device == 1
        tic;
        Ctrl_Opt = 1;
        for Frame = 1: pControl.Assembly_Time
            if (mod(Frame-1,pControl.Epoch) == 0)
                Ctrl_Opt = 1 - Ctrl_Opt;
                if Ctrl_Opt == 1
                    ControlFG(opt_device,1e6,0,pControl.Voltage*0.1,pControl.Voltage*0.95);
                else
                    ControlFG(opt_device,1e6,0,pControl.Voltage*0.1,pControl.Voltage*0.1);
                end

            end
            [Rg, Psi6, C6] = Status_Update(camera, pImage, pOP, Ctrl_Opt, Frame, 4);
            if (Psi6 >= pOP.final_Thresh)
                Succ = Succ + 1;
                break;
            end
            pause(Frame/4-toc);
        end
    else
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Anisotropic field Quench %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alternatively turn on two orthogonal fields
        tic;
        Ctrl_Opt = 1;
        for Frame = 1: pControl.Assembly_Time
            if (mod(Frame-1,pControl.Epoch) == 0)
                Ctrl_Opt = 3 - Ctrl_Opt;
                if Ctrl_Opt == 1
                    ControlFG(opt_device,1e6,0,pControl.Voltage*0.1,pControl.Voltage*0.95);
                elseif Ctrl_Opt == 2
                    ControlFG(opt_device,1e6,0,pControl.Voltage*0.95,pControl.Voltage*0.1);
                end

            end
            [Rg, Psi6, C6] = Status_Update(camera, pImage, pOP, Ctrl_Opt, Frame, 4);
            if (Psi6 >= pOP.final_Thresh)
                Succ = Succ + 1;
                break;
            end
            pause(Frame/4-toc);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Anisotropic field Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tic;
        Ctrl_Opt = 1;
        for Frame = 1: pControl.Assembly_Time
            if (mod(Frame-1,pControl.Epoch) == 0)
                Ctrl_Opt = 3 - Ctrl_Opt;
                if Ctrl_Opt == 1
                    ControlFG(opt_device,1e6,0,pControl.Voltage*0.1,pControl.Voltage*0.95);
                elseif Ctrl_Opt == 2
                    ControlFG(opt_device,1e6,0,pControl.Voltage*0.95,pControl.Voltage*0.1);
                end

            end
            [Rg, Psi6, C6] = Status_Update(camera, pImage, pOP, Ctrl_Opt, Frame, 4);
            if (Psi6 >= pOP.final_Thresh)
                Succ = Succ + 1;
                break;
            end
            pause(Frame/4-toc);
        end
    end
end