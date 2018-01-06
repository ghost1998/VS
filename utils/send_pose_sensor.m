function send_pose_sensor(Pose_matrix, pos_sub, pos_pub, msg,  model_id)

%     Takes a 4 x 4 homogeneous  transformation matrix (with respect to our convention )and shift the sensor to that pose. 
    R_axis_change= [0 ,-1, 0; 0, 0, -1; 1, 0, 0 ];

    
    Rotation_matrix_new = inv(R_axis_change) * (Pose_matrix(1:3,1:3)) * R_axis_change;
    quat = rotm2quat(Rotation_matrix_new);
    
    
    msg.Pose.Position.Z = -Pose_matrix(2,4);
    msg.Pose.Position.X = Pose_matrix(3,4);
    msg.Pose.Position.Y = -Pose_matrix(1,4);
    msg.Pose.Orientation.W = quat(1);
    msg.Pose.Orientation.X = quat(2);
    msg.Pose.Orientation.Y = quat(3);
    msg.Pose.Orientation.Z = quat(4);
    send(pos_pub,msg);

end