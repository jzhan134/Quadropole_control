clear
clc
clf
warning off
close all
addpath('/home/aledonbde/Desktop/QUADRUPOLE_SELF_ASSEMBLY_CONTROL/Image_Analysis');
Color_code = [0,0,255;  255 0 0; 0 255 0;0 128 0; 0 192 0];
color = Color_code./255;

% io video files
fig = figure(1);
% v0 = VideoWriter('/home/aledonbde/Desktop/IA.avi');
% v0.FrameRate = 7;
% open(v0);
fig.InnerPosition = [1321 1 600 485];
v = VideoReader('/home/aledonbde/Desktop/good_anisotropic.avi');
frames = v.NumberOfFrames; %#ok<VIDREAD> % 243

% parameters
Load_Parameters;

% for f = 150:frames
for f = 243
    
    % read the num f frame in the format of unit8
    Window = read(v,f); %#ok<VIDREAD>
    
    % identify particle center
    % first column is height from above, second column is width from left
    % pxl_cnt is the coordinate in the unit of pixel
    % real_cnt is the coordinate in the unit of radius
    pxl_cnt = TrackParticles(Window(:,:,1), thresh, psize);
    real_cnt = [pxl_cnt(:,1),pxl_cnt(:,2:3).*scale./(diam/2)]; 

    % Image analysis module
    Rg = OP_Rg(real_cnt*(diam/2));
    [P_Type, OUTPUT_GB_ORI, OUTPUT_DOMAIN_ORI, PSI6, C6] = IMAGE_ANALYSIS(real_cnt);
    PSI6 = PSI6/Psi6scale;
    C6 = C6/C6scale;
    
    % plot results
    imshow(Window)
    hold on
    if C6 > 0.8
        for i = 1:size(pxl_cnt,1)
            plot(pxl_cnt(i,3),pxl_cnt(i,2),'ko','markersize', 4,...
                'MarkerFaceColor',color(min(P_Type(i),3)+2,:))
        end
    end
    hold off
    title(sprintf('t: %.0ds; C_6: %.2f; psi_6: %.2f', f-99, C6, PSI6));
%     this_frame = getframe(gcf);
%     writeVideo(v0,this_frame.cdata);
end
% close(v0);
%     [x,y] = ginput();
%     [~,tt] = min((pxl_cnt(:,2) - y).^2 + (pxl_cnt(:,3)-x).^2)
%     plot(pxl_cnt(tt,3),pxl_cnt(tt,2),'ko','markersize', 4,...
%                 'MarkerFaceColor','m')



