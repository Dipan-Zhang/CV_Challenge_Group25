
function [big_im,big_im_alpha,vx,vy,ceilrx,ceilry,floorrx,floorry,...
    leftrx,leftry,rightrx,rightry,backrx,backry,backfirx,backfiry] = ...
    TIP_get5rects_f(im,vx,vy,irx,iry,orx,ory, firx, firy);

%% expand the image so that each "face" of the box is a proper rectangle
[ymax,xmax,cdepth] = size(im);
lmargin = -min(orx);
rmargin = max(orx) - xmax;
tmargin = -min(ory);
bmargin = max(ory) - ymax;
big_im = zeros([ymax+tmargin+bmargin xmax+lmargin+rmargin cdepth]);
big_im_alpha = zeros([size(big_im,1) size(big_im,2)]);
big_im(tmargin+1:end-bmargin,lmargin+1:end-rmargin,:) = im2double(im);
big_im_alpha(tmargin+1:end-bmargin,lmargin+1:end-rmargin) = 1;


% update all variables for the new image
vx = vx + lmargin;
vy = vy + tmargin;
irx = irx + lmargin;
iry = iry + tmargin;
orx = orx + lmargin;
ory = ory + tmargin;
backfirx = firx + lmargin;
backfiry = firy + tmargin;
%%

%% define the 5 rectangles

% ceiling 
ceilrx = [orx(1) orx(2) irx(2) irx(1)];
ceilry = [ory(1) ory(2) iry(2) iry(1)];
if (ceilry(1)<tmargin && ceilry(2)<tmargin)
    ceilry(1) =tmargin;
    ceilrx(1) = round(find_line_x(vx,vy,irx(1),iry(1),ceilry(1)));
    ceilry(2)=tmargin;
    ceilrx(2) = round(find_line_x(vx,vy,irx(2),iry(2),ceilry(2)));
else
    if (ceilry(1) < ceilry(2))
         ceilrx(1) = round(find_line_x(vx,vy,ceilrx(1),ceilry(1),ceilry(2)));
         ceilry(1) = ceilry(2);
    else
         ceilrx(2) = round(find_line_x(vx,vy,ceilrx(2),ceilry(2),ceilry(1)));
         ceilry(2) = ceilry(1);
    end
end
% floor
floorrx = [irx(4) irx(3) orx(3) orx(4)];
floorry = [iry(4) iry(3) ory(3) ory(4)];
if (floorry(3)>ymax+tmargin && floorry(4)>ymax+tmargin)
    floorry(3) =ymax+tmargin;
    floorrx(3) = round(find_line_x(vx,vy,irx(3),iry(3),floorry(3)));
    floorry(4)=ymax+tmargin;
    floorrx(4) = round(find_line_x(vx,vy,irx(4),iry(4),floorry(4)));
else
    if (floorry(3) > floorry(4))
         floorrx(3) = round(find_line_x(vx,vy,floorrx(3),floorry(3),floorry(4)));
         floorry(3) = floorry(4);
    else
         floorrx(4) = round(find_line_x(vx,vy,floorrx(4),floorry(4),floorry(3)));
         floorry(4) = floorry(3);
    end
end

% left
leftrx = [orx(1) irx(1) irx(4) orx(4)];
leftry = [ory(1) iry(1) iry(4) ory(4)];
if (leftrx(1)<lmargin && leftrx(4)<lmargin)
    leftrx(1) = lmargin;
    leftry(1)= round(find_line_y(vx,vy,irx(1),iry(1),leftrx(1)));
    leftrx(4) = lmargin;
    leftry(4) = round(find_line_y(vx,vy,irx(4),iry(4),leftrx(4)));
else
    if (leftrx(1) < leftrx(4))
         leftry(1) = round(find_line_y(vx,vy,leftrx(1),leftry(1),leftrx(4)));
         leftrx(1) = leftrx(4);
    else
         leftry(4) = round(find_line_y(vx,vy,leftrx(4),leftry(4),leftrx(1)));
         leftrx(4) = leftrx(1);
    end
end

% right
rightrx = [irx(2) orx(2) orx(3) irx(3)];
rightry = [iry(2) ory(2) ory(3) iry(3)];
if (rightrx(2)>xmax+lmargin && rightrx(3)>xmax+lmargin)
    rightrx(2) = xmax+lmargin;
    rightry(2)= round(find_line_y(vx,vy,irx(2),iry(2),rightrx(2)));
    rightrx(3) = xmax+lmargin;
    rightry(3) = round(find_line_y(vx,vy,irx(3),iry(3),rightrx(3)));
else
    if (rightrx(2) > rightrx(3))
         rightry(2) = round(find_line_y(vx,vy,rightrx(2),rightry(2),rightrx(3)));
         rightrx(2) = rightrx(3);
    else
         rightry(3) = round(find_line_y(vx,vy,rightrx(3),rightry(3),rightrx(2)));
         rightrx(3) = rightrx(2);
    end
end

backrx = irx;
backry = iry;
