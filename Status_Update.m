% OP: time, control option, particle number, Psi6, C6, Rg
% Coord: time, particle index, x coordinate, y coordinate

function [Rg, Psi6, C6] = Status_Update(camera, pImage, pOP, Ctrl_Opt, Frame, fps)

    % get snapshot and coordinate data for each frame (second)
    Window = getsnapshot(camera);
    [cnt, pnum] = TrackParticles(Window, pImage.thresh, pImage.psize);
    xyz = cnt.*pImage.scale;
    CurrFrame = [(1:size(xyz,1))',xyz];
    Image_Analysis(xyz, pnum);
    % calculate order parameters and generate output entry
    [Rg, Psi6, C6] = OrderParameter(xyz,pOP);
    OP_Data = [Frame/fps, Ctrl_Opt, pnum, Psi6, C6, Rg/1000];
    Coord_Data = [(Frame-1)*ones(pnum,1)./fps, (1:pnum)', xyz(:,1:2)];

    % display parameters in command window
    fprintf('Cycle  Time  #Part  Rg C6  Psi6  Opt  SR\n');
    fprintf('%01d     %01d   %01d   %01d    %.2f  %.2f  %.2f  %d  %d/%d\n',...
        cycle, Frame/fps, pnum, Rg, C6_corr, Psi6_corr, Ctrl_Opt, Succ, cycle-1);

    % save data into corresponding files
    if Frame == 0
        imwrite(Window,Tiff_File,'tif','Compression','none');
        save(Data_File, 'OP_Data','-ascii');
        save(Coordinate_File, 'Coord_Data','-ascii');
    else
        imwrite(Window,Tiff_File,'tif','Compression','none','WriteMode','append');
        save(Data_File, 'OP_Data', '-append','-ascii')
        save(Coordinate_File, 'Particle_Data','-append','-ascii');
    end
end