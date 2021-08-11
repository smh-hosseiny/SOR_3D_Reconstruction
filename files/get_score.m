function [score] = get_score(px,py,Ix,Iy,FeaturesMatrix)
rng = get_front_points(px, py);
px = px(rng); py = py(rng);
L = single([px;py]);
distance = pdist2(L',[Ix;Iy].','minkowski');

Th = 10;
Idx = [];
for i=1:length(px)
   row = distance(i,:);
   indices = find(row < Th);
   Idx = [Idx, indices];
end
I = unique(Idx);
if isempty(I)
    score = 1e2;
else
%     plot(px,py,'color','y','linewidth',1);
%     hold on; 
%     plot(Ix(I),Iy(I),'g+');
    Keypoints = FeaturesMatrix(:, I);
    score = min(vecnorm(Keypoints,2,2))/(size(Keypoints,2));
end

end
