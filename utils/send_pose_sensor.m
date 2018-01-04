function send_pose_sensor(pos_sub, pos_pub , dr ,msg, model_id)



%     pos = receive(pos_sub);
%     Rotation_matrix = quat2rotm([pos.Pose(model_id).Orientation.W, pos.Pose(model_id).Orientation.X, pos.Pose(model_id).Orientation.Y, pos.Pose(model_id).Orientation.Z]);
%     Rotation_matrix_new = (R_axis_change) * (Rotation_matrix) * inv(R_axis_change);
%     Homogeneous_transform = zeros(4,4);
%     Homogeneous_transform(1:3,1:3) = Rotation_matrix_new;
%     Homogeneous_transform(:,4) = [ -pos.Pose(model_id).Position.Y, -pos.Pose(model_id).Position.Z, pos.Pose(model_id).Position.X, 1];
    R_axis_change= [0 ,-1, 0; 0, 0, -1; 1, 0, 0 ];
    
    
    Homogeneous_transform = eye(4);
    
    Rotd = eul2rotm([dr(6), dr(5), dr(4)]);%ZYX
    Td = [Rotd [dr(1);dr(2);dr(3)]];
    
    
    Homogeneous_transform=Homogeneous_transform*[Td;0 0 0 1];

    
    Rotation_matrix_new = inv(R_axis_change) * (Homogeneous_transform(1:3,1:3)) * R_axis_change;
    quat = rotm2quat(Rotation_matrix_new);
    
    
    msg.Pose.Position.Z = -Homogeneous_transform(2,4);
    msg.Pose.Position.X = Homogeneous_transform(3,4);
    msg.Pose.Position.Y = -Homogeneous_transform(1,4);
    msg.Pose.Orientation.W = quat(1);
    msg.Pose.Orientation.X = quat(2);
    msg.Pose.Orientation.Y = quat(3);
    msg.Pose.Orientation.Z = quat(4);
    send(pos_pub,msg);
    a = 1;
    
end