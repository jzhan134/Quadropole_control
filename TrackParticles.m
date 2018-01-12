function cnt = TrackParticles(Window, thresh, psize)

% old image filteration algorithm (alternative)
% frametemp = bpass(Window,1,psize); % bandpass filter - correct noises of brightness
% pk = pkfnd(frametemp,thresh,11); % find pixels with brightness exceed threshold value
% cnt = cntrd(frametemp,pk,15,0); % identify centers

% identify all bright pixels, idx is the height from top, idy is width from left
[idx, idy] = find (Window > thresh);
Window = double(Window);
% Group bright pixels into particles by their relative locations
cnt = []; % 2-by-n matrix with [x,y] coordinates in pixel for each column
while (~isempty(idx))
    dist = sqrt((idx - idx(1)).^2 + (idy - idy(1)).^2);
    indice = find(dist <= psize);
%     curr_x = idx(indice);
%     curr_y = idy(indice);
%     curr_bri = Window(curr_x,curr_y);
%     mean_x = 0;
%     mean_y = 0;
%     for i = 1:size(curr_bri,2)
%         mean_x = mean_x + sum(curr_bri(:,i).*curr_x);
%     end
%     for i = 1:size(curr_bri,1)
%         mean_y = mean_y + sum(curr_bri(i,:).*curr_y');
%     end
%     mean_x = mean_x/sum(sum(curr_bri));
%     mean_y = mean_y/sum(sum(curr_bri));
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

cnt = [1:size(cnt,2);cnt]';
end