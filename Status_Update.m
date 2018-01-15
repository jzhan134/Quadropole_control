% take snapshot of the particles
Window = getsnapshot(camera);
% convert the image to particle coordinates data in the unit of pixel
pxl_cnt = TrackParticles(Window(:,:,1), thresh, psize);

% convert the data into nm and unit of particle radius
real_cnt = [pxl_cnt(:,1),pxl_cnt(:,2:3).*scale];
rad_cnt = [pxl_cnt(:,1),pxl_cnt(:,2:3).*scale./(diam/2)];

% conduct image analysis and calculate OP
[P_Type, OUTPUT_GB_ORI, OUTPUT_DOMAIN_ORI, G_PSI6, G_C6] = IMAGE_ANALYSIS(rad_cnt);
G_PSI6 = G_PSI6/Psi6scale;
G_C6 = G_C6/C6scale;
Rg = OP_Rg(real_cnt);

% format the output data structures
OP_Data = [sec, Ctrl_Opt, size(real_cnt,1), G_PSI6, G_C6, Rg/1000, OUTPUT_GB_ORI, OUTPUT_DOMAIN_ORI];
Coord_Data = [sec*ones(size(real_cnt,1),1), P_Type, real_cnt];

% display parameters in command window
fprintf('#%01d - %01ds (%01d); pnum: %01d; [%0.2f, %0.2f, %0.2f] total: %d\n',...
    cycle, sec, Ctrl_Opt, size(real_cnt,1), G_C6, G_PSI6, Rg/1000, Succ);

% save data
if Frame == 1
    imwrite(Window,Tiff_File,'tif','Compression','none');
    save(OP_File, 'OP_Data','-ascii');
    save(Coordinate_File, 'Coord_Data','-ascii');
else
    imwrite(Window,Tiff_File,'tif','Compression','none','WriteMode','append');
    save(OP_File, 'OP_Data', '-append','-ascii')
    save(Coordinate_File, 'Coord_Data','-append','-ascii');
end
