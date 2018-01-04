function L = getibvsL(features_original , features_iter,depth_app, K)
L = [];

for i = 1:2:size(features_iter,1)
    L1 = L_matrix(features_iter(i),features_iter(i+1),depth_app , K);
    L = [L;L1];
end
    
end 


function L = L_matrix(X,Y,Z, K)
    x = (X - K(1 , 3))/K(1 , 1);
    y = (Y - K(2 , 3))/K(2 , 2);
%     x = (X*K(1 , 1)) + K(1 , 3);
%     y = (Y*K(2 , 2))+  K(2 , 3);
% x = X;
% y = Y;
    z = Z;
    L = [-1/z,0, x/z,x*y,-(1+x^2),y;
          0,-1/z,y/z,1+y^2,-x*y,-x];
end