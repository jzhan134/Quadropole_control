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

%}

file_name = '/home/aledonbde/Desktop/'; % data save path
Succ = 0; % counter of success cycles
for cycle = 1:Total_Cycle
    
    % create new data files
    Tiff_File = sprintf('%s/Cycle_%d.tif',file_name,cycle); % image file
    OP_File = sprintf('%s/Cycle_%d_OP.mat',file_name,cycle); % order parameter
    Coordinate_File = sprintf('%s/Cycle_%d_Coord.mat',file_name,cycle); % particle coordinate

    % disassemble stage - usethe smallest field until liquid state or maximum time reached
    ControlFG(opt_device,1e6,1e6,Voltage*0.1,Voltage*0.1);
    Ctrl_Opt = 0;
    sec = 0; % sec is kept as 0 for the disassemble stage
    tic;
    for Frame = 1:Disassemble_Time
        Status_Update;
        if (Rg >= dilute_thresh)
            break;
        end
        pause(Frame - toc);
    end
    
    % isotropic field with alternative quench/relax control strategy
    % Ctrl_Opt: (0) relax; (1) quench
    while (sec <= Assembly_Time && opt_device == 1)
        tic;
        %  control strategy
        if (mod(sec, Epoch) == 0)
            Ctrl_Opt = 1 - Ctrl_Opt;
            if Ctrl_Opt == 1
                ControlFG(1, 1e6, 1e6, Voltage*0.95, Voltage*0.95);
            else
                ControlFG(1, 1e6, 1e6, Voltage*0.1, Voltage*0.1);
            end
        end

        % update status every second
        Status_Update;

        % terminate early if perfect crystal is made
        if (G_PSI6 >= final_Thresh)
            Succ = Succ + 1;
            break;
        end

        % hold until next loop (second)
        sec = sec + 1;
        pause(1 - toc);
    end

    % anisotropic field with alternative fields 
    % Ctrl_Opt: (0)relax; (1)NS; (2)WE
    Ctrl_Opt = 1;
    while (sec <= Assembly_Time && opt_device == 2)
        tic;
        % control strategy
        if (mod(sec, Epoch) == 0)
            Ctrl_Opt = 3 - Ctrl_Opt;
            if Ctrl_Opt == 1
                ControlFG(2, 1e6, 1e6, Voltage*0.1, Voltage*0.95);
            elseif Ctrl_Opt == 2
                ControlFG(2, 1e6, 1e6, Voltage*0.95, Voltage*0.1);
            end
        end

        % update status every second
        Status_Update;

        % terminate early if perfect crystal is made
        if (Psi6 >= final_Thresh)
            Succ = Succ + 1;
            break;
        end

        % hold on until next loop (second)
        sec = sec + 1;
        pause(1 - toc);
    end

    % anisotropic field with decision making
    % control option is based on the orientation of grain boudary
    while (sec <= Assembly_Time && opt_device == 2)
        tic;
        if (mod(sec, Epoch) == 0)
            Status_Update;
            if (OUTPUT_GB_ORI>=45 || OUTPUT_GB_ORI <= -45)
                ControlFG(2, 1e6, 1e6, Voltage*0.1, Voltage*0.95);
            else 
                ControlFG(2, 1e6, 1e6, Voltage*0.95, Voltage*0.1);
            end
        end

        % update status every second
        Status_Update;

        % terminate early if perfect crystal is made
        if (Psi6 >= final_Thresh)
            Succ = Succ + 1;
            break;
        end

        % hold on until next loop (second)
        sec = sec + 1;
        pause(1 - toc);
    end
end