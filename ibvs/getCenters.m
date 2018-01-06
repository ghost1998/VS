function centers = getCenters(im)

 
%  ---------------------------------------------------------------------------------
centers = [];
radii = [];

%  ---------------------------------------------------------------------------------
[x,y] = MaskRed(im);
a = rgb2gray(y);
bw = a < 0.07;
stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength');
center = stats.Centroid;
diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
[argvalue , argmax] = max(diameter);


center = center(argmax, :);
diameter = diameter(argmax, :);
radius = diameter/2;

 
centers = [centers; center];
radii = [radii; radius];
%  ---------------------------------------------------------------------------------
[x,y] = MaskGreen(im);
a = rgb2gray(y);
bw = a < 0.07;
stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength');
center = stats.Centroid;
diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
[argvalue , argmax] = max(diameter);


center = center(argmax, :);
diameter = diameter(argmax, :);
radius = diameter/2;

 
centers = [centers; center];
radii = [radii; radius];
%  ---------------------------------------------------------------------------------
[x,y] = MaskBlue(im);
a = rgb2gray(y);
bw = a < 0.07;
stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength');
center = stats.Centroid;
diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
[argvalue , argmax] = max(diameter);


center = center(argmax, :);
diameter = diameter(argmax, :);
radius = diameter/2;

 
centers = [centers; center];
radii = [radii; radius];
%  ---------------------------------------------------------------------------------
[x,y] = MaskYellow(im);
a = rgb2gray(y);
bw = a < 0.07;
stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength');
center = stats.Centroid;
diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
[argvalue , argmax] = max(diameter);


center = center(argmax, :);
diameter = diameter(argmax, :);
radius = diameter/2;

 
centers = [centers; center];
radii = [radii; radius];
%  ---------------------------------------------------------------------------------


%  imshow(im)
%  hold on
%  viscircles(centers,radii);
%  hold off


