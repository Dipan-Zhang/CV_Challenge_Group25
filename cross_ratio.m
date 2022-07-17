function F = cross_ratio(x,c)
% use to calculate pixel distance with the same space distance.
% input:    x = [x,y] unknown pixel coordinate
%           c = [vx,vy: x,y-coordinate of vanishing point
%                ax,ay: x,y-coordinate of the start point.
%                bx,by: x,y-coordinate of the middle point
%               ]
% output:  //

F = [norm([x(1)-c(3),x(2)-c(4)])*norm([c(5)-c(1),c(6)-c(2)])-2*norm([c(5)-x(1),c(6)-x(2)])*norm([c(3)-c(1),c(4)-c(2)]);
    (x(1)-c(1))/(x(2)-c(2))-(c(3)-c(1))/(c(4)-c(2))];

end