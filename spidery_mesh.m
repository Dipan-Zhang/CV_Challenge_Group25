function spidery_mesh(vx,vy,sizeIma,varargin)
% if the 5 rectangles are given, show spidery mesh, otherwise show the rays from the vanishing point.
% input: vx: x-coordinate of vanishing point
%        vy: y-coordinate of vanishing point
%        sizeIma: size of image
%        varargin: 12 vertices of the 5 rectangles with the order same
%                  in Tour Into the Picture Figure 4(c). [x1, y1; x2,
%                  y2;...] 
%                   fiveRec = [floorrx(1),floorry(1);
%                             floorrx(2),floorry(2);
%                             floorrx(4),floorry(4);
%                             floorrx(3),floorry(3);
%                             leftrx(4),leftry(4);
%                             rightrx(3),rightry(3);
%                             ceilrx(4),ceilry(4);
%                             ceilrx(3),ceilry(3);
%                             ceilrx(1),ceilry(1);
%                             ceilrx(2),ceilry(2);
%                             leftrx(1),leftry(1);
%                             rightrx(2),rightry(2)];
% output: //

hold on
%% draw the vanishing point
vp = scatter(vx,vy);
vp.SizeData = 100;
vp.LineWidth = 0.6;
vp.MarkerEdgeColor = 'b';
vp.MarkerFaceColor = [0 0.5 0.5];
n = 20;
%% draw the rays from the vanishing point
if (nargin ==3)
theta = linspace(-pi/2,pi/2,n);
theta = theta(2:end-1);

xline(vx,'Color','b')
ySta = vy - tan(theta) * vx;
yEnd = vy + tan(theta) * (sizeIma(2) - vx);
line([zeros(1,n-2);ones(1,n-2)*sizeIma(2)],[ySta;yEnd],'Color','b')

end
%% draw lines
if (nargin > 3)
    ver5Rec = varargin{1};

    yPoints = linspace(ver5Rec(7,2),ver5Rec(1,2),n);
    xPoints = linspace(ver5Rec(1,1),ver5Rec(2,1),n);
    line([ones(1,n)*ver5Rec(1,1);ones(1,n)*ver5Rec(2,1)],[yPoints;yPoints],'Color','k')
    line([xPoints;xPoints],[ones(1,n)*ver5Rec(7,2);ones(1,n)*ver5Rec(1,2)],'Color','k')

    xCell = find_line_x(vx,vy,xPoints,ver5Rec(7,2),ver5Rec(9,2));
    line([xPoints;xCell],[ones(1,n)*ver5Rec(7,2);ones(1,n)*ver5Rec(9,2)],'Color','k')

    xFloor = find_line_x(vx,vy,xPoints,ver5Rec(1,2),ver5Rec(3,2));
    line([xPoints;xFloor],[ones(1,n)*ver5Rec(1,2);ones(1,n)*ver5Rec(3,2)],'Color','k')

    yLeft = find_line_y(vx,vy,ver5Rec(1,1),yPoints,ver5Rec(5,1));
    line([ones(1,n)*ver5Rec(1,1);ones(1,n)*ver5Rec(5,1)],[yPoints;yLeft],'Color','k')

    yRight = find_line_y(vx,vy,ver5Rec(2,1),yPoints,ver5Rec(6,1));
    line([ones(1,n)*ver5Rec(2,1);ones(1,n)*ver5Rec(6,1)],[yPoints;yRight],'Color','k')

    % line in the plane, which parallel to the photo plane
    ax = min(ver5Rec(9,1),ver5Rec(11,1));
    ay = min(ver5Rec(9,2),ver5Rec(11,2));
    d = floor((ver5Rec(7,2)-ay)/5);
    bx = find_line_x(ax,ay,vx,vy,ay+d);
    by = ay + d;
    i = 0; % counter
    while(norm([bx-ver5Rec(7,1),by-ver5Rec(7,2)])> norm([ax-bx,ay-by]))
        i = i+1;
        fun = @(x)cross_ratio(x,[vx,vy,ax,ay,bx,by]);
        x = fsolve(fun,[(3*bx-ax)/2,(3*by-ay)/2]);
        cx = x(1);
        cy = x(2);
        tempx = find_line_x(vx,vy,ver5Rec(10,1),ver5Rec(10,2),by);
        tempy = find_line_y(vx,vy,ver5Rec(6,1),ver5Rec(6,2),tempx);
        if (by > ver5Rec(9,2))
            line([bx,tempx],[by,by],'Color','k');
        end
        if (tempx < ver5Rec(12,1))
            line([tempx,tempx],[by,tempy],'Color','k');
        end
        if (bx > ver5Rec(11,1))
            line([bx,bx],[by,tempy],'Color','k');
        end
        if (tempy < ver5Rec(3,2))
            line([bx,tempx],[tempy,tempy],'Color','k');
        end
        if cx > ver5Rec(7,1)
            break
        end
        ax = bx;
        ay = by;
        bx = cx;
        by = cy;
    end
end

%% quit
hold off
end
