%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Global Psi 6 Order Parameter and Local Order Parameter C6 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Order parameter algorithm, the order parameters are scaled between 0 and 1, and adjusted by error
% Based on Nelson and Halperin, Physical Review B, 1979
% and ten Wolde et al., J. Chem. Phys., 1996

% Radius of gyration, nm
function Rg = OP_Rg(xyz)
pnum = size(xyz,1);
xm = mean(xyz(:,2));
ym = mean(xyz(:,3));
rgx = sqrt(sum((xyz(:,2)-xm).^2)/pnum);
rgy = sqrt(sum((xyz(:,3)-ym).^2)/pnum);
rg = sqrt(rgx^2 + rgy^2)/1000;
% Rghex = sqrt(5*pnum)/3*aeff;
% Rgmax = Rghex*1.4;
% Rgmin = Rghex;
Rg = rg*1000.0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%