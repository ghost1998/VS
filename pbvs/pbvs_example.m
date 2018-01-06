clear
clc

addpath(genpath('../utils'))

try
    rosinit;
end

pos_pub = rospublisher('gazebo/set_model_state','gazebo_msgs/ModelState');
pos_sub = rossubscriber('/gazebo/model_states');

msg = rosmessage(pos_pub);

img_sub = rossubscriber('/vi_sensor/camera_depth/camera/image_raw','BufferSize', 1);
% disp_img_sub = rossubscriber('/vi_sensor/camera_depth/depth/disparity','BufferSize', 1);
% disp_caminfo_sub = rossubscriber('/vi_sensor/camera_depth/depth/disparity','BufferSize', 1);

% pt_sub = rossubscriber('/vi_sensor/camera_depth/depth/points','BufferSize', 1);

msg.ModelName = 'vi_sensor';
msg.ReferenceFrame = 'world';

pos = receive(pos_sub);
model_id = find(strcmp(pos.Name,'vi_sensor'));
cam.K=[205.46963709898583, 0.0, 320.5; 0.0, 205.46963709898583, 240.5; 0.0, 0.0, 1.0];


R_axis_change= [0 ,-1, 0; 0, 0, -1; 1, 0, 0 ];


dt =1;
vc = [4 1 1  0 -pi/2  0];
send_velocity_sensor(pos_sub, pos_pub , vc ,msg, model_id,dt , true)
% dr = [4 1 1  0 0  0];
% send_pose_sensor(pos_sub, pos_pub , dr ,msg, model_id)
pause(0.1)
img=readImage(receive(img_sub));
img_original = img;


Pose_matrix = get_sensor_pose(pos_sub, pos_pub, model_id);
% send_pose_sensor_from_matrix(Pose_matrix, pos_sub, pos_pub, msg,  model_id);
p_desired = Pose_matrix;
% Store this pose as p_desired



% dr = [4 0 0  0 -pi/2  0];

vc = [4 0 0  0 0  0];
send_velocity_sensor(pos_sub, pos_pub , vc ,msg, model_id,dt , true)
% send_pose_sensor(pos_sub, pos_pub , dr ,msg, model_id)
pause(0.1)
img=readImage(receive(img_sub));
Pose_matrix = get_sensor_pose(pos_sub, pos_pub, model_id);
p1 = Pose_matrix;
% Store this pose as p1


%Make relative stransformation R from p1 and p2



imgg = rgb2gray(img);
img_originalg = rgb2gray(img_original);



lambda   = 0.1;
iter=1;
stop_velocity = 0.0001;
max_iterations = 1000;
stop_error = 0.00001;

pbvs(p_desired ,img_original , lambda, pos_sub, pos_pub ,img_sub, model_id, stop_velocity , max_iterations , stop_error)