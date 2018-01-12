%%%%%%%%%%%%%%%%%%%%%%%%% Automatic Image Analysis - real-time version %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Last update: 171015 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
The input/output data structures:
    CurrFrame: n-by-3 matrix [i, x, y] in the unit of particle radius, i is [1, pnum]

    P_Type: Type of each particle as -1: pheriphal, 0: out-of-phase, >1 crystalline
    OUTPUT_GB_ORI: [-90,90] grain boundary orientation, -90 if not applicable
    OUTPUT_DOMAIN_ORI: [-30, 30] domain orientation for up to 2 domains; -30 if not applicable
    G_PSI6: global psi6
    G_C6: global c6

%}
function [P_Type, OUTPUT_GB_ORI, OUTPUT_DOMAIN_ORI, G_PSI6, G_C6] = IMAGE_ANALYSIS(CurrFrame)

% verify particle index starts from 1
    if CurrFrame(1,1) == 0
        CurrFrame(:,1) = (1:size(CurrFrame,1))';
    end
    
% distinguish between grain boundary/ crystalline, and peripheral particles
    [P_Type, neighboridx, L_theta6, G_PSI6, G_C6] = CATEGORIZATION(CurrFrame);

    
% if any grain boundary clusters exist beyong the major grain boundary particles, regroup
% them into crystalline
    if ~isempty(CurrFrame(P_Type==0,:))
        GB = CONNECTIVITY(CurrFrame(P_Type == 0,1), neighboridx);
        for domain = 2:size(GB,2)
            P_Type(GB{domain}) = 1;
        end
    end
    
    
% group crystalline particles into domains, number them by increasing indices. if
% a domain less than 5 particles exist, group them into grain boundary
if max(P_Type) >= 1
    Type = CONNECTIVITY(CurrFrame(P_Type > 0,1), neighboridx);
    domain_idx = 1;
    for i = 1:size(Type,2)
        if size(Type{i},2) <= 5
            P_Type(Type{i}) = 0;
        else
            P_Type(Type{i}) = domain_idx;
            domain_idx = domain_idx +1;
        end
    end
end

% Find domain centers and orientations, representing in (-30 30] degree
    OUTPUT_DOMAIN_ORI = [-30 -30];    
    Domain_Center = zeros(3,max(P_Type));
    for i = 1:max(P_Type)
        Domain_Center(1,i) = mean(CurrFrame((P_Type==i),2)) ;
        Domain_Center(2,i) = mean(CurrFrame((P_Type==i),1)) ;
        Domain_Center(3,i) = median(L_theta6((P_Type==i)));
    end
    for i = 1:min(max(P_Type),2)
        OUTPUT_DOMAIN_ORI(i) = Domain_Center(3,i);
    end
    
% Find grain boundary orientation when less than two domains exist
    x_mean = mean(CurrFrame(P_Type == 0,1));
    y_mean = mean(CurrFrame(P_Type == 0,2));
    if max(P_Type) <= 2
        bin = 1:180;
        sig = NaN(1,size(bin,2));
        for i = 1:size(bin,2)
            degree = bin(i)*pi/180;
            fac1 = abs(CurrFrame(P_Type == 0,1).*tan(degree) - CurrFrame(P_Type == 0,2) ...
                + (-tan(degree)*x_mean + y_mean));
            fac2 = sqrt(tan(degree).^2+1);
            sig(i) = sqrt(sum((fac1./fac2).^2)/size(CurrFrame(P_Type == 0,2),1));
        end
        [~,best_Dirc] = min(sig);
        OUTPUT_GB_ORI = bin(best_Dirc)-90;

    else
        OUTPUT_GB_ORI = -90;
    end
end