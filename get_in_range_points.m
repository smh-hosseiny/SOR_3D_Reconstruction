function [Ix, Iy, FeaturesMatrix] = get_in_range_points(Ix, Iy, FeaturesMatrix, x, y)

x = double(x);
index = (Ix >= min(x) & Ix <= max(x));
Ix = Ix(index);
Iy = Iy(index);

valid = ones(size(Ix));
for i=1:length(Ix)
   [~, I] = mink(abs(x-Ix(i)),10);
   if Iy(i) < min(y(I))
       valid(i) = 0;
   end
end
valid = boolean(valid);

Ix = Ix(valid).'; 
Iy = Iy(valid).';
FeaturesMatrix = FeaturesMatrix(valid,:).';

end