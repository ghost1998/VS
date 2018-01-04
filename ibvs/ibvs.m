function ibvs(img_original,depth_app,lambda, pos_sub, pos_pub ,img_sub, model_id, camK)

    msg = rosmessage(pos_pub);
    msg.ModelName = 'vi_sensor';
    msg.ReferenceFrame = 'world';
    R_axis_change= [0 ,-1, 0; 0, 0, -1; 1, 0, 0 ];
    
    iter=1
    while(1)
        iter = iter +1 ;
        fprintf('iter:%d\n',iter);
        
        img=readImage(receive(img_sub));
        
        %-----------------------------------------------------------------------------------------------
        [features_original , features_iter] = getsurffeatures(img_original, img);
%         depth_app = 4;
        L = getibvsL(features_original , features_iter,depth_app, camK);
    
        error = features_iter - features_original;
        norme = norm(error)
        vc = -lambda*pinv(L)*error;

    
        %-----------------------------------------------------------------------------------------------
        subplot(2,2,1),imagesc(img);title('Image');axis([0 640 0 480]);
        subplot(2,2,2),imagesc(img_original);title('Desired image');axis([0 640 0 480])
    
        normeError=norm(error);
        if(normeError < 1 || iter > 2000) break;end
        if(norm(vc) < 0.0001 ) break;end
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