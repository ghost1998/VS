function Lsd=getinteraction_intensity(imgd,camK,sd_len,Z)
%imgd=imgd';
imgd=double(imgd);
bord=10;
KK=camK;
px = KK(1,1);
py = KK(2,2);
v0=KK(1,3)/2;
u0=KK(2,3)/2;
%img2=img(bord:size(imgd,1)-bord,bord:size(imgd,2)-bord);

%(Gx1 Gy1) = gradient(imgd);
%Gx = zeros(size(imgd));
%Gy = zeros(size(imgd));


% Gx=zeros(size(imgd));
% Gx(:,1:end-1) = (2047/8418)*(imgd(:,2:end) - imgd(:,1:end-1));
% Gx(:,1:end-2) = Gx(:,1:end-2)+(913/8418)*(imgd(:,3:end) - imgd(:,1:end-2));
% Gx(:,1:end-3) = Gx(:,1:end-3)+(913/8418)*(imgd(:,4:end) - imgd(:,1:end-3));
% 
% Gy=double(zeros(size(imgd)));
% Gy(1:end-1,:) = (2047/8418)*(imgd(2:end,:) - imgd(1:end-1,:));
% Gy(1:end-2,:) = Gy(1:end-2,:)+(913/8418)*(imgd(3:end,:) - imgd(1:end-2,:));
% Gy(1:end-3,:) = Gy(1:end-3,:)+(913/8418)*(imgd(4:end,:) - imgd(1:end-3,:));


Gx_arr=double(zeros(size(imgd)));
Gy_arr=double(zeros(size(imgd)));
h_filt = fspecial('gaussian', [11 11], 1.2);
%Gx2 = imfilter(Gx1,h_filt,'replicate');
%Gy2 = imfilter(Gy1,h_filt,'replicate');
m = 1;
Lsd=double(zeros(sd_len,6));
%Lsd_arr=zeros(size(imgd,1),size(imgd,2),6);
xy_arr=double(zeros(sd_len,2));
for i=bord+1:size(imgd,1)-bord %i is row
    for j=bord+1:size(imgd,2)-bord %j is col
        %Ix=px*Gx1(i,j);
        %Iy=py*Gy1(i,j);

        
        Gx = (2047.0 *(imgd(i,j+1) - imgd(i,j-1))+913.0 *(imgd(i,j+2) - imgd(i,j-2))+112.0 *(imgd(i,j+3) - imgd(i,j-3)))/8418.0;
        Gy = (2047.0 *(imgd(i+1,j) - imgd(i-1,j))+913.0 *(imgd(i+2,j) - imgd(i-2,j))+112.0 *(imgd(i+3,j) - imgd(i-3,j)))/8418.0;
        Gx_arr(i,j)=Gx;
        Gy_arr(i,j)=Gy;
        
        Ix=px*Gx;
        Iy=py*Gy;
        
        
        y = double((i - 1 - u0)/px) ;
        x = double((j - 1 - v0)/py) ;
        %vpPixelMeterConversion::convertPoint(cam,j,i,x,y)  ;
        
        Zinv =  1/Z;
        
        xy_arr(m,1)=Ix;
        xy_arr(m,2)=Iy;
        xy_arr(m,3)=x;
        xy_arr(m,4)=y;
        
        Lsd(m,1) = Ix * Zinv;
        Lsd(m,2) = Iy * Zinv;
        Lsd(m,3) = -(x*Ix+y*Iy)*Zinv;
        Lsd(m,4) = -Ix*x*y-(1+y*y)*Iy;
        Lsd(m,5) = (1+x*x)*Ix + Iy*x*y;
        Lsd(m,6)  = Iy*x-Ix*y;
        %Lsd_arr(i,j,1:6)= Lsd(m,1:6);
        m=m+1;
    end
end
end
