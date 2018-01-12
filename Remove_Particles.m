function Remove_Particles(opt_device, camera, thresh, psize)
% initialize default field condition and focus the camera
ControlFG(opt_device,1e6,1e6,1.5,1.5);
preview(camera)
input('Press ENTER focus on the center of the quadrupole');
stoppreview(camera)

% Control number of particles in the field to 300
opt_prompt = strcat('Choose a control options:',...
    '\n    (1) Positive DEP',...
    '\n    (2) Negative DEP',...
    '\n    (3) Count number',...
    '\n    (0) Exit\n');
while true
    opt = input(opt_prompt);
    if (opt == 0)
        break;
    elseif (opt == 1)
        ControlFG(opt_device,1e3,1e3,1.5,1.5);
    elseif (opt == 2)
        ControlFG(opt_device,1e6,1e6,1.5,1.5);
    elseif (opt == 3)
        Window = getsnapshot(camera);
        [cnt, pnum] = TrackParticles(Window, thresh, psize);
        figure(2)
        warning off;
        imshow(Window)
        hold on
        plot(cnt(:,2),cnt(:,1),'rx')
        hold off
        fprintf('Total particle number: %d\n',pnum);
        figure(1)
    end
end
close(figure(2));
clc
end