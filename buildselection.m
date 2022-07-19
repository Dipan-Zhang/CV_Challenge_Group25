function [xmin,xmax,ymin,ymax,gim,g_sele,alpha,gf] = buildselection(im)

%g: selected foreground
%gim: origin picture with blurred picture 
%xmin,xmax,ymin,ymax: outer frame of the foregrounds
%g_sele: foreground rectangles

[mask,xi2,yi2] = roipoly(im);% generates a binary plot black 0 white 1 and
                             % enables the user to click on the stroke point 
                             % and double-click to end; outputs the graph(mask) 
                             % inside the points and the points

ymin = round(min(xi2));
xmin = round(min(yi2));
ymax = round(max(xi2));
xmax = round(max(yi2));
x = [xmin;xmax];
y = [ymin;ymax];
red=immultiply(mask,im(:,:,1));
blue=immultiply(mask,im(:,:,3));
green=immultiply(mask,im(:,:,2));
g=cat(3,red,green,blue);

maskf = ~mask;
redf=immultiply(maskf,im(:,:,1));
bluef=immultiply(maskf,im(:,:,3));
greenf=immultiply(maskf,im(:,:,2));
gf=cat(3,redf,greenf,bluef);%make the Foreground black 

%create gaussian noise for the selected area
gbim = filtered(g, x, y);
gim = gf+gbim;

%determine the smallest square(s) which surround the foreground(s)
[i,j] = find(g(:,:,1)~=0);
ximax = max(j);
ximin = min(j);
yimax = max(i);
yimin = min(i);
g_sele = g(yimin:yimax,ximin:ximax,:);
%figure;
%imshow(g_sele);
siz = size(g_sele);
alpha = ones(siz(1), siz(2));
alpha(g_sele(:,:,2)==0)=0;
end
% Move the pointer over the initial vertex of the polygon that you 
% selected. The pointer changes to a circle . Click either mouse button.
% 
% Double-click the left mouse button. This action creates a vertex 
% at the point under the mouse pointer and draws a straight line
% connecting this vertex with the initial vertex.
% 
% Right-click the mouse. This draws a line connecting the last 
% vertex selected with the initial vertex; it does not create a
% new vertex at the point under the mouse.
