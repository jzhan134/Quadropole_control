function Remove_Particles(opt_device, camera, thresh, psize)

% center the camera
preview(camera)
input('Press ENTER focus on the center of the quadrupole');
stoppreview(camera)

% Control number of particles
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
        figure(1)
        ControlFG(opt_device,1e3,1e3,1.5,1.5);
    elseif (opt == 2)
        figure(1)
        ControlFG(opt_device,1e6,1e6,1.5,1.5);
    elseif (opt == 3)
        Window = getsnapshot(camera);
        cnt = TrackParticles(Window(:,:,1), thresh, psize);
        figure(2)
        imshow(Window)
        hold on
        plot(cnt(:,3),cnt(:,2),'rx') 
        hold off
        fprintf('Total particle number: %d\n',size(cnt,1));
    end
end
close(figure(2));
clc
end