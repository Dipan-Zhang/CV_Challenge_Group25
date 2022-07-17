
function [ firx, firy,gim,g_sele,alpha_sele,gf] = TIP_GUI_f(im,vx, vy, irx, iry, orx,ory)

[ymax,xmax,cdepth] = size(im);

%% select picture
imshow(im);

%% select the foreground(s)
[xmins,xmaxs,ymins,ymaxs,gim,g_sele,alpha_sele,gf] = buildselection(im); %user defined selected picture
%g: selected foreground
%gim: origin picture with blurred picture 
%xmin,xmax,ymin,ymax: outer frame of the foregrounds
%g_sele: foreground rectangles
%%

figure;
imshow(im);

% draw the rectangle which surrounds the foreground
frx = [xmins;xmaxs];
fry = [ymins;ymaxs];
imshow(im);
hold on;

firx = round([fry(1) fry(2) fry(2) fry(1) fry(1)]);
firy =  round([frx(1) frx(1) frx(2) frx(2) frx(1)]);
plot(firx,firy,'black'); 
hold off;

  % draw
  imshow(im);
  hold on;
  plot(irx,iry,'b'); 
  plot(firx,firy,'black'); 
  plot([vx irx(1)], [vy iry(1)], 'r-.');
  plot([orx(1) irx(1)], [ory(1) iry(1)], 'r');
  plot([vx irx(2)], [vy iry(2)], 'r-.');
  plot([orx(2) irx(2)], [ory(2) iry(2)], 'r');
  plot([vx irx(3)], [vy iry(3)], 'r-.');
  plot([orx(3) irx(3)], [ory(3) iry(3)], 'r');
  plot([vx irx(4)], [vy iry(4)], 'r-.');
  plot([orx(4) irx(4)], [ory(4) iry(4)], 'r');
  spidery_mesh(vx,vy,size(im))
  hold off;

  drawnow;

