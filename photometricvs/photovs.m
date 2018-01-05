function photovs(img_original,depth_app,lambda, mu, pos_sub, pos_pub ,img_sub, model_id, camK)

    msg = rosmessage(pos_pub);
    msg.ModelName = 'vi_sensor';
    msg.ReferenceFrame = 'world';
    R_axis_change= [0 ,-1, 0; 0, 0, -1; 1, 0, 0 ];
    
    
    img_originalg = rgb2gray(img_original);
    features_desired=getintensityfeatures(img_originalg) ;
    feature_length=length(features_desired);
    
    
    iter=1;
    while(1)
        iter = iter +1 ;
        fprintf('iter:%d\n',iter);
        
        img=readImage(receive(img_sub));
        imgg=rgb2gray(img);
        
        %-----------------------------------------------------------------------------------------------
        
        


%         features=getintensityfeatures(imgg) ;
%         error=features-features_desired;
%         
%         Lsd=getinteraction_intensity(img_originalg,camK,feature_length,depth_app);
%         Hsd = Lsd'*Lsd;
%         diagHsd = eye(size(Hsd,1)).*Hsd;
%         H = inv((mu * diagHsd) + Hsd);
%         e = H * Lsd' *error ;
%         vc = -lambda*e;
        
        %-----------------------------------------------------------------------------------------------
        features=getintensityfeatures(imgg) ;
        error=features-features_desired;

        LIx=getphotometricvsL(img_originalg,camK,feature_length,depth_app);
        H = LIx' * LIx;
        vc = -lambda * inv(H + mu*(eye(size(H, 1)).*H)) * (LIx') * (error);
        
        %-----------------------------------------------------------------------------------------------
        subplot(2,2,1),imagesc(img);title('Image');axis([0 640 0 480]);
        subplot(2,2,2),imagesc(img_original);title('Desired image');axis([0 640 0 480])
    
%         normeError=norm(error)
%         if(normeError < 1 || iter > 2000) break;end
%         if(norm(vc) < 0.0001 ) break;end
        normv_arr(iter)=norm(vc);
        subplot(2,2,3),plot(normv_arr);title('Velocity');
        err_arr(iter)=norm(error);    
        subplot(2,2,4),plot(err_arr);title('Error');
    
        %-----------------------------------------------------------------------------------------------
    
    
     
        fprintf('v:%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,|Tc|=%f\n',vc(1),vc(2),vc(3),vc(4),vc(5),vc(6),sum(vc.*vc));     
        dt = 1;
        send_velocity_sensor(pos_sub, pos_pub , vc ,msg, model_id,dt)

        pause(0.1);
    end


end 