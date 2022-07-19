% read in sample image
addpath('datensatz\');
addpath('icon\');
im = imread('oil-painting.png');
figure(1)
imshow(im)
sz = size(im);
focal_length = max(sz(1),sz(2))/2/tan(pi/180*30/2);
   
%% decide whether rotation is needed;
prompt =['Do you need to rotate the picture to a suitable position?  \n' ...
    ' If no please input 1，If yes, please input 2,'];
input_RO = input(prompt); % number VPs 1 or 2)
if input_RO == 1
    flag_RO = 1;
else
    flag_RO = 2;
end


if flag_RO == 2 
   figure(1)
   imshow(im)
   im = rotate(im); 
end

%% deal with multiple vanishing points
prompt =['How many Vanishing Points do you have(1/2)?  \n' ...
    'Please type the number and then type Enter.'];
input_VP = input(prompt); % number VPs 1 or 2)
if input_VP == 1
    flag_VP = 1;
else
    flag_VP = 2;
end


if flag_VP == 2 
   figure(1)
   imshow(im)
   Pos = ginput(5); % select the 4 vertices of a rectangle plan from the left 
                    % top corner in clockwise direction, then choose the direction 
                    % of the second vp (accroding to the 45 degree line)
   orgPos = Pos';

   im = proj_adjust(im,orgPos,focal_length);
   figure(2)
   imshow(im)
end

%%

% resize image for faster processing
im = imresize(im, 0.5);

%% deal with foreground(s)
flag_f = 0;
prompt_f =['Do you have foreground(0 for none and N for N foregrounds)? \n' ...
    'Please type 0/N(number), and then type Enter'];
input_f = input(prompt_f); % user defined number of vanishing points

if input_f ~= 0
    flag_f = 1;
    gbim = im;
    figure(1);
    [vx,vy,irx,iry,orx,ory] = TIP_GUI(im); %find the 5 rectangles and vanshing point
        gvx = vx;
        gvy = vy;

    for i = 1:input_f
        figure(1);
        [firx, firy,gbim, g_sele,alpha_sele,gf] = TIP_GUI_f(gbim,gvx, gvy, irx, iry, orx,ory);%select foreground and output the seleted picture

        [bim,bim_alpha,vx,vy,ceilrx,ceilry,floorrx,floorry,...
        leftrx,leftry,rightrx,rightry,backrx,backry,backfirx,backfiry] = ...
        TIP_get5rects_f(gbim,gvx,gvy,irx,iry,orx,ory, firx, firy);%Get the 
            % expanded image, which includes the five boxes as well as the box
            % of foreground, with coordinates in the expanded figure
        [ggbim,gbim_alpha,vx,vy,gceilrx,gceilry,gfloorrx,gfloorry,...
        gleftrx,gleftry,grightrx,grightry,gbackrx,gbackry,gbackfirx,gbackfiry] = ...
        TIP_get5rects_f(gf,gvx,gvy,irx,iry,orx,ory, firx, firy);%Process blurred images


        [botton_pointx,botton_pointy] = node([vx;vy], ...
            [gbackfirx(4);gbackfiry(4)],[floorrx(3),floorry(3)], ...
            [floorrx(4),floorry(4)]); %find the intersection point of the line 
                                      %build by vanishing point and the
                                      %lower left corner of foreground and
                                      %the underline of the floor to
                                      %roughly decide the projection y
                                      %coordinate in 3D scene
                               
        if botton_pointx < 0 %make sure the projected foreground will not go
                             % "beyond" the left wall.
            botton_pointx = 0;
        end

        Firx{i} = firx;
        Firy{i} = firy;
        G_sele{i} = g_sele;
        Alpha_sele{i} = alpha_sele;
        Gf{i} = gf;
        Botton_pointx{i} = botton_pointx;
        Botton_pointy{i} = botton_pointy;
        Bim{i} = bim;
        Bim_alpha{i} = bim_alpha;
        Backfirx{i} = backfirx;
        Backfiry{i} = backfiry;
        Ggbim{i} = ggbim;
        Gbim_alpha{i} = gbim_alpha;
        Gbackfirx{i} = gbackfirx;
        Gbackfiry{i} = gbackfiry;
    end
else
    
    figure(1);
    [vx,vy,irx,iry,orx,ory] = TIP_GUI(im);

    % Find the cube faces and compute the expended image
    [bim,bim_alpha,vx,vy,ceilrx,ceilry,floorrx,floorry,...
    leftrx,leftry,rightrx,rightry,backrx,backry] = ...
    TIP_get5rects(im,vx,vy,irx,iry,orx,ory);
    
end


 %predefine the five rectangles to make it easier later for spider mesh
    fiveRec = [floorrx(1),floorry(1);
        floorrx(2),floorry(2);
        floorrx(4),floorry(4);
        floorrx(3),floorry(3);
        leftrx(4),leftry(4);
        rightrx(3),rightry(3);
        ceilrx(4),ceilry(4);
        ceilrx(3),ceilry(3);
        ceilrx(1),ceilry(1);
        ceilrx(2),ceilry(2);
        leftrx(1),leftry(1);
        rightrx(2),rightry(2)];


% Draw the Vanishing Point and the 4 faces on the image
figure(2);
imshow(bim);
hold on;
plot(vx,vy,'w*','LineWidth',5);
plot([ceilrx ceilrx(1)], [ceilry ceilry(1)], 'y-','LineWidth',5);
plot([floorrx floorrx(1)], [floorry floorry(1)], 'm-','LineWidth',5);
plot([leftrx leftrx(1)], [leftry leftry(1)], 'c-','LineWidth',5);
plot([rightrx rightrx(1)], [rightry rightry(1)], 'g-','LineWidth',5);
hold off;

%% Generate fronto-parallel views of each plane

xmin = min([ceilrx(1) floorrx(4) leftrx(1)]);
xmax = max([ceilrx(2) floorrx(3) rightrx(3)]);
ymin = min([leftry(1) rightry(2) ceilry(1)]);
ymax = max([leftry(4) rightry(3) floorry(3)]);

destn = [xmin xmax xmax xmin; ymin ymin ymax ymax];
spidery_mesh(vx,vy,size(im),fiveRec) %create spider mesh
% Calculate 3D dimension
x1 = find_line_x(vx,vy,irx(1),iry(1),0);
x2 = find_line_x(vx,vy,irx(2),iry(2),0);
%%
ratio1 = (fiveRec(9,1)-fiveRec(10,1))/(fiveRec(7,1)-fiveRec(8,1));
ratio2 = (fiveRec(3,1)-fiveRec(4,1))/(fiveRec(1,1)-fiveRec(2,1));
ratio3 = (fiveRec(11,2)-fiveRec(5,2))/(fiveRec(7,2)-fiveRec(1,2));
ratio4 = (fiveRec(12,2)-fiveRec(6,2))/(fiveRec(8,2)-fiveRec(2,2));
ratio = [ratio1,ratio2,ratio3,ratio4];
sim_trig_ratio = max(ratio);

%sim_trig_ratio = (x2-x1)/(irx(2)-irx(1));
depth = focal_length*(sim_trig_ratio-1);

%% transform of the image by homography matrix.
source_ceil = [ceilrx; ceilry];
[h_ceil,t_ceil] = computeH(source_ceil, destn);
ceil = imtransform(bim, t_ceil, 'xData',[xmin xmax],'yData',[ymin ymax]);

source_floor = [floorrx; floorry];
[h_floor,t_floor] = computeH(source_floor, destn);
floor = imtransform(bim, t_floor, 'xData',[xmin xmax],'yData',[ymin ymax]);

source_back = [backrx; backry];
[h_back,t_back] = computeH(source_back, destn);
back = imtransform(bim, t_back, 'xData',[xmin xmax],'yData',[ymin ymax]);
alpha_b = ones(size(back,1),size(back,2));

source_left = [leftrx; leftry];
[h_left,t_left] = computeH(source_left, destn);
left = imtransform(bim, t_left, 'xData',[xmin xmax],'yData',[ymin ymax]);

source_right = [rightrx; rightry];
[h_right,t_right] = computeH(source_right, destn);
right = imtransform(bim, t_right, 'xData',[xmin xmax],'yData',[ymin ymax]);

%% deal with foreground(s)
if flag_f ~= 0
    for i = 1:input_f
        gsource_floor = [floorrx; floorry];
        [gh_floor,gt_floor] = computeH(gsource_floor, destn);
        gfloor = imtransform(Ggbim{i}, gt_floor, 'xData',[xmin xmax],'yData',[ymin ymax]);
        [rowfq, colfq] = find(gfloor(20:(end-20),20:(end-20),1) ==0);
        gyf = size(gfloor(:,:,1),1) - max(rowfq);
    
        source_foreground = [Backfirx{i}; Backfiry{i}];
        [h_foreground,t_foreground] = computeH(source_foreground, destn);
        foreground = imtransform(G_sele{i}, t_foreground,'XYScale',1);
        size_f = size(foreground);
        alpha_foreground = imtransform(Alpha_sele{i}, t_foreground,'XYScale',1);

        Gyf{i} = gyf;
        Foreground{i} = foreground;
        Alpha_foreground{i} = alpha_foreground;

    end
end
%%
%% display 3D sufraces

% ceil_planex = [0 0 0; depth depth depth];
% ceil_planey = [xmin (xmax+xmin)/2 xmax; xmin (xmin+xmax)/2 xmax];
% ceil_planez = [ymax ymax ymax; ymax ymax ymax];
% 
% floor_planex = [depth depth depth; 0 0 0];
% floor_planey = [xmin (xmax+xmin)/2 xmax; xmin (xmin+xmax)/2 xmax];
% floor_planez = [ymin ymin ymin; ymin ymin ymin];
% 
% back_planex = [depth depth depth; depth depth depth];
% back_planey = [xmin (xmax+xmin)/2 xmax; xmin (xmin+xmax)/2 xmax];
% back_planez = [ymax ymax ymax; ymin ymin ymin];
% 
% left_planex = [0 depth/2 depth; 0 depth/2 depth];
% left_planey = [xmin xmin xmin; xmin xmin xmin];
% left_planez = [ymax ymax ymax; ymin ymin ymin];
% 
% right_planex = [depth depth/2 0; depth depth/2 0];
% right_planey = [xmax xmax xmax; xmax xmax xmax];
% right_planez = [ymax ymax ymax; ymin ymin ymin];
[~,ind]=max(ratio);

switch(ind)
    case 1 % top
        full_depth = abs(fiveRec(9,2) - fiveRec(7,2));
        a=0;    %top
        b=(1-abs(fiveRec(3,2) - fiveRec(1,2))/full_depth)*depth;    %floor
        c=(1-abs(fiveRec(11,2) - fiveRec(7,2))/full_depth)*depth;   %left
        d=(1-abs(fiveRec(12,2) - fiveRec(8,2))/full_depth)*depth;   %right
    case 2 % floor
        full_depth = abs(fiveRec(3,2) - fiveRec(1,2));
        a=(1-abs(fiveRec(9,2) - fiveRec(7,2))/full_depth)*depth;
        b=0;
        c=(1-abs(fiveRec(5,2) - fiveRec(1,2))/full_depth)*depth;
        d=(1-abs(fiveRec(6,2) - fiveRec(2,2))/full_depth)*depth;
    case 3 % left
        full_depth = abs(fiveRec(11,1) - fiveRec(7,1));
        a=(1-abs(fiveRec(9,1) - fiveRec(7,1))/full_depth)*depth;
        b=(1-abs(fiveRec(3,1) - fiveRec(1,1))/full_depth)*depth;
        c=0;
        d=(1-abs(fiveRec(12,1) - fiveRec(8,1))/full_depth)*depth;
    case 4 % right
        full_depth = abs(fiveRec(12,1) - fiveRec(8,1));
        a=(1-abs(fiveRec(10,1) - fiveRec(8,1))/full_depth)*depth;
        b=(1-abs(fiveRec(4,1) - fiveRec(2,1))/full_depth)*depth;
        c=(1-abs(fiveRec(11,1) - fiveRec(7,1))/full_depth)*depth;
        d=0;
end

ceil_planex = [a a a ; depth depth depth];
ceil_planey = [xmin (xmax+xmin)/2 xmax; xmin (xmin+xmax)/2 xmax];
ceil_planez = [ymax ymax ymax; ymax ymax ymax];

floor_planex = [depth depth depth; b b b];
floor_planey = [xmin (xmax+xmin)/2 xmax; xmin (xmin+xmax)/2 xmax];
floor_planez = [ymin ymin ymin; ymin ymin ymin];

back_planex = [depth depth depth; depth depth depth];
back_planey = [xmin (xmax+xmin)/2 xmax; xmin (xmin+xmax)/2 xmax];
back_planez = [ymax ymax ymax; ymin ymin ymin];

left_planex = [c (depth-c)/2 depth; c (depth-c)/2 depth];
left_planey = [xmin xmin xmin; xmin xmin xmin];
left_planez = [ymax ymax ymax; ymin ymin ymin];

right_planex = [depth (depth-d)/2 d; depth (depth-d)/2 d];
right_planey = [xmax xmax xmax; xmax xmax xmax];
right_planez = [ymax ymax ymax; ymin ymin ymin];
%% deal with foreground(s)
if flag_f ~= 0 
    for i = 1:input_f
        backfiry = Backfiry{i};
        foreground_depth = ymin + depth*(backfiry(1)-floorry(1))/(floorry(4)-floorry(1)) ;
        botton_pointx = Botton_pointx{i};
        foreground_left = botton_pointx;
        gbackfirx = Gbackfirx{i};
        foreground_right = foreground_left +1.5*(gbackfirx(3)-gbackfirx(4)) ; %enlarge the foregrounds with a suitable parameter 1.5
        foreground_height = 1.5*abs(backfiry(1)-backfiry(4));
        fl = foreground_left;
        fr = foreground_right;
        fh = foreground_height;
        fd = Gyf{i} * (depth/size(floor(:,:,1),1));
        foreground_x = [fd fd fd; fd fd fd];
        foreground_y = [fl (fr+fl)/2 fr; fl (fl+fr)/2 fr];
        foreground_z = [fh fh fh; 0 0 0];
 
        Foreground_x{i} = foreground_x;
        Foreground_y{i} = foreground_y;
        Foreground_z{i} = foreground_z;
    end

end

% create the surface and texturemap it with a given image

view = figure('name','3DViewer');
set(view,'windowkeypressfcn','set(gcbf,''Userdata'',get(gcbf,''CurrentCharacter''))') ;
set(view,'windowkeyreleasefcn','set(gcbf,''Userdata'','''')') ;
set(view,'Color','black');
 hold on
 %% warp the foreground(s)
if flag_f ~= 0 
    for i = 1:input_f    
        h = warp(Foreground_x{i},Foreground_y{i},Foreground_z{i},Foreground{i}); 
        set(gcf,'renderer','opengl'); 
        set(h,'FaceAlpha',  'texturemap', 'AlphaDataMapping', 'none', 'AlphaData',Alpha_foreground{i});
    end

end
%%

%% Wrap the images over the surface defined by the coordinates(x,y,z)
warp(ceil_planex,ceil_planey,ceil_planez,ceil);
warp(floor_planex,floor_planey,floor_planez,floor);
warp(back_planex,back_planey,back_planez,back);
warp(left_planex,left_planey,left_planez,left);
warp(right_planex,right_planey,right_planez,right);


% Show 3D-Space
axis equal;  % make X,Y,Z dimentions be equal
axis vis3d;  % freeze the scale for better rotations
axis off;    % turn off the stupid tick marks
camproj('perspective');  % make it a perspective projection

% set camera position and Direction
camx = -1500;
camy = 0;
camz = 0;
camup([0,0,1]);
campos([camx camy camz]);

