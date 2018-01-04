function [corr1 , corr2] = getSURF(orig, iter)

finalimage1 = orig;
finalimage2 = iter;

[rows, columns, numberOfColorChannels] = size(finalimage1);
if(numberOfColorChannels > 1)
    finalimage1 = rgb2gray(finalimage1);
end

[rows, columns, numberOfColorChannels] = size(finalimage2);
if(numberOfColorChannels > 1)
    finalimage2 = rgb2gray(finalimage2);
end

% finalimage1 = im2double(gray1);
% finalimage2 = im2double(gray2);
features1 = detectSURFFeatures(finalimage1);
features2 = detectSURFFeatures(finalimage2);
[f1,vpts1] = extractFeatures(finalimage1,features1);
[f2,vpts2] = extractFeatures(finalimage2,features2);
indexPairs = matchFeatures(f1, f2);
matchedPoints1 = vpts1(indexPairs(:,1),:);
matchedPoints2 = vpts2(indexPairs(:,2),:);
% showMatchedFeatures(finalimage1, finalimage2, matchedPoints1, matchedPoints2);

for i=1:matchedPoints1.Count
xa(i,:)=matchedPoints1.Location(i);
ya(i,:)=matchedPoints1.Location(i,2);
xb(i,:)=matchedPoints2.Location(i);
yb(i,:)=matchedPoints2.Location(i,2);
end

P1 = horzcat(xa, ya);
P2 = horzcat(xb, yb);
sz = size(finalimage1);
corr1 = P1;
corr2 = P2;

end