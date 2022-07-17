%% Two endpoints of two lines are known, find the coordinates of their intersection
% % Background.
% 1. It is known that: four points in the plane X1, Y1, X2, Y2
% where X1 and Y1 determine a straight line and X2 and Y2 determine a straight line
% 2. Task: solve for the intersection of the line determined by X1 and Y1, and the line determined by X2 and Y2

%Reference: https://blog.csdn.net/weixin_39549377/article/details/107129428
function [X Y]= node( X1,Y1,X2,Y2 )

if X1(1)==Y1(1)
   X=X1(1);
   k2=(Y2(2)-X2(2))/(Y2(1)-X2(1));
   b2=X2(2)-k2*X2(1); 
   Y=k2*X+b2;
end
if X2(1)==Y2(1)
   X=X2(1);
   k1=(Y1(2)-X1(2))/(Y1(1)-X1(1));
   b1=X1(2)-k1*X1(1);
   Y=k1*X+b1;
end
if X1(1)~=Y1(1)&X2(1)~=Y2(1)
   k1=(Y1(2)-X1(2))/(Y1(1)-X1(1));
   k2=(Y2(2)-X2(2))/(Y2(1)-X2(1));
   b1=X1(2)-k1*X1(1);
   b2=X2(2)-k2*X2(1);
    if k1==k2
      X=[];
      Y=[];
   else
   X=(b2-b1)/(k1-k2);
   Y=k1*X+b1;
   end
end
