function pbvs(p_desired ,img_original , lambda, pos_sub, pos_pub ,img_sub, model_id , stop_velocity , max_iterations , stop_error)
    msg = rosmessage(pos_pub);
    msg.ModelName = 'vi_sensor';
    msg.ReferenceFrame = 'world';
    R_axis_change= [0 ,-1, 0; 0, 0, -1; 1, 0, 0 ];
    
    iter=1
    while(1)
        iter = iter +1 ;
        fprintf('iter:%d\n',iter);
        img=readImage(receive(img_sub));
        
        Pose_matrix = get_sensor_pose(pos_sub, pos_pub, model_id);
        p1 = Pose_matrix;
        % Store this pose as p1

        % p_relative = inv(p1) * (p_desired);
        p_relative = inv(p_desired) * (p1);
        p_relative = p_relative ./ p_relative(4, 4);
        R_relative = p_relative(1:3,1:3);
        
        %-----------------------------------------------------------------------------------------------
        %Calculate error
        et = p_relative(1:3 , 4 );
    
        t = p_relative(1:3, 1:3);
        axangles = rotm2axang(t);
        axangle_vector = axangles(1 : 3) * axangles(4);
        er = axangle_vector';
        error = [et;er];
    
        %-----------------------------------------------------------------------------------------------
        %Calculate velocity
    
        t_relative = p_relative(1:3 , 4 );
    
        t = p_relative(1:3, 1:3);
        axangles = rotm2axang(t);
        axangle_vector = axangles(1 : 3) * axangles(4);
        theta_u = axangle_vector';
    
        vc1 = -lambda * R_relative' * t_relative;
        vc2 = -lambda * theta_u;
        vc = [vc1;vc2];
    
        %-----------------------------------------------------------------------------------------------
        subplot(2,2,1),imagesc(img);title('Image');axis([0 640 0 480]);
        subplot(2,2,2),imagesc(img_original);title('Desired image');axis([0 640 0 480])
    
        normeError=norm(error);
        
        
        if(normeError < stop_error || iter > max_iterations) break;end
        
        if(norm(vc) < stop_velocity ) break;end
        
        normv_arr(iter)=norm(vc);
        subplot(2,2,3),plot(normv_arr);title('Velocity');
        err_arr(iter)=norm(error);    
        subplot(2,2,4),plot(err_arr);title('Error');
    
        %-----------------------------------------------------------------------------------------------
    
    
  
        fprintf('v:%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,|Tc|=%f\n',vc(1),vc(2),vc(3),vc(4),vc(5),vc(6),sum(vc.*vc));     
        dt = 1;
        send_velocity_sensor(pos_sub, pos_pub , vc ,msg, model_id,dt , false)

        pause(0.1);
    end

    
end