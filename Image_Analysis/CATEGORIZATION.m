%{
    Define particles as 
      peripheral (-1)
      grain boundary (0)
      crystalline (1)

%}
function [Particle_Category, neighboridx, L_theta6, G_PSI6, G_C6] = CATEGORIZATION(CurrFrame)

Particle_Category = zeros(size(CurrFrame,1),1);

% Calculate local psi6 value for each particle
[L_PSI6, L_theta6, neighboridx, G_PSI6, G_C6] = ORDER_PARAMETER(CurrFrame);
Psi6scale = 0.82; % correction factor of Psi6 due to image noises
L_PSI6 = L_PSI6/Psi6scale;

% center particles to (0,0)
x_mean = mean(CurrFrame(:,2));
y_mean = mean(CurrFrame(:,3));
CurrFrame(:,2) = CurrFrame(:,2) - x_mean;
CurrFrame(:,3) = CurrFrame(:,3) - y_mean;

% rotate particles coordinates so that the elliptical contour is roughly align with x-y
% directions
    deg = (60)/180*pi;
    for i = 1:size(CurrFrame,1) 
        result = [cos(deg), -sin(deg); sin(deg), cos(deg)]*[CurrFrame(i,2);CurrFrame(i,3)];
        CurrFrame(i,2) = result(1);
        CurrFrame(i,3) = result(2);
    end

for i = 1:size(CurrFrame,1)  
%     if i == 38
%         x = 1;
%     end
    if (CurrFrame(i,2))^2/max(abs(CurrFrame(:,2)))^2 + ...
            (CurrFrame(i,3))^2/max(abs(CurrFrame(:,3)))^2 >= 0.5 % peripheral
        Particle_Category(i) = -1;
    elseif  (size(neighboridx{i},2) ~= 7 || L_PSI6(i) < 0.8) % out-of-phase
        Particle_Category(i) = 0;
    else % crystalline
        Particle_Category(i) = 1;
    end
end
end