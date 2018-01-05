clear
clc

addpath(genpath('../utils'))
% roslaunch rotors_gazebo vi_sensor.launch
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




dr = [4 1 1  0 -pi/2  0];
send_pose_sensor(pos_sub, pos_pub , dr ,msg, model_id)
pause(0.1)
img=readImage(receive(img_sub));
img_original = img;


dr = [4 0 0  0 -pi/2  0];
send_pose_sensor(pos_sub, pos_pub , dr ,msg, model_id)
pause(0.1)
img=readImage(receive(img_sub));


imgg = rgb2gray(img);
img_originalg = rgb2gray(img_original);


lambda   = 0.7;
depth_app = 4;
mu =  0.1;

photovs(img_original,depth_app,lambda,mu, pos_sub, pos_pub ,img_sub, model_id, cam.K)