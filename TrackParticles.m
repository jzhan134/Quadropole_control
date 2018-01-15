%{
cnt: n-by-3 matrix with 
    (1) particle index from 1 to pnum, 
    (2) particle height from top
    (3) particle width from left
%}
function cnt = TrackParticles(Window, thresh, psize)

% old image filteration algorithm (alternative)
% frametemp = bpass(Window,1,psize); % bandpass filter - correct noises of brightness
% pk = pkfnd(frametemp,thresh,11); % find pixels with brightness exceed threshold value
% cnt = cntrd(frametemp,pk,15,0); % identify centers

% identify all bright pixels
[idx, idy] = find (Window > thresh);

% Group bright pixels into particles by their relative locations
cnt = [];
while (~isempty(idx))
    dist = sqrt((idx - idx(1)).^2 + (idy - idy(1)).^2);
    indice = find(dist <= psize);
    cnt = cat(2, cnt, [mean(idx(indice)); mean(idy(indice))]);
    idx(indice) = [];
    idy(indice) = [];
end

% remove particles that are 20 pixels aways from the nearest particle 
% This indicates it is stuck
remove_list = [];
for i = 1:size(cnt,2)
    diffe = sort(sqrt((cnt(1,:)-cnt(1,i)).^2 + (cnt(2,:)-cnt(2,i)).^2));
    if diffe(2) >= 20
        remove_list = cat(2, remove_list, i);
    end        
end
cnt(:,remove_list) = [];

% reorganize output data structure
cnt = [1:size(cnt,2);cnt]';
end