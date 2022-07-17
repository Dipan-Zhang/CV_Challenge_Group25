function adjIma = proj_adjust(orgIma,pos,focLen)
% change the perspectivity of the image according a quadrangle.
% input:      orgIma: orginal image
%             orgPos: the 4 vertices of a plan in the orginal image with
%             clockwise direction from left-top corner and a point show the
%             direction of the will be adjusted vp (x>y vp in y direction)
%                     [x1, x2, x3, x4, x5; y1, y2, y3, y4, y5]
% output:     ima: adjusted image, the empty part filled with black.

% size of the orgIma=[ymax,xmax,...]
szOrgIma = size(orgIma);
orgPos = pos(:,1:4);
flag = pos(:,5);
mid = [szOrgIma(2)/2,szOrgIma(1)/2]';

% calculate the original proportion of the rectangle based on the top line
% with VP in y direction and left line with VP in x direction
if flag(1)>flag(2)
    wid = norm([orgPos(1,1)-orgPos(1,2),orgPos(2,1)-orgPos(2,2)]);  % width of the selected quadrangle
    dep = focLen * (norm([orgPos(1,1)-orgPos(1,2),orgPos(2,1)-orgPos(2,2)])/norm([orgPos(1,3)-orgPos(1,4),orgPos(2,3)-orgPos(2,4)])-1);
    c2 = norm(cross([mid-orgPos(:,1);0],[orgPos(:,1)-orgPos(:,2);0]))/wid;
    x1 = find_line_x(orgPos(1,1),orgPos(2,1),orgPos(1,4),orgPos(2,4),mid(2));
    x2 = find_line_x(orgPos(1,2),orgPos(2,2),orgPos(1,3),orgPos(2,3),mid(2));
    b1 = abs(x1 - x2);
    d1 = focLen * (norm([orgPos(1,1)-orgPos(1,2),orgPos(2,1)-orgPos(2,2)])/b1 - 1);
    hei = sqrt((c2*dep/d1)^2+dep^2);
else
    hei = norm([orgPos(1,1)-orgPos(1,4),orgPos(2,1)-orgPos(2,4)]);  % height of the selected quadrangle
    dep = focLen * (norm([orgPos(1,1)-orgPos(1,4),orgPos(2,1)-orgPos(2,4)])/norm([orgPos(1,3)-orgPos(1,2),orgPos(2,3)-orgPos(2,2)])-1);
    c2 = norm(cross([mid-orgPos(:,1);0],[orgPos(:,1)-orgPos(:,4);0]))/hei;
    y1 = find_line_y(orgPos(1,1),orgPos(2,1),orgPos(1,2),orgPos(2,2),mid(1));
    y2 = find_line_y(orgPos(1,3),orgPos(2,3),orgPos(1,4),orgPos(2,4),mid(1));
    b1 = abs(y1-y2);
    d1 = focLen * (norm([orgPos(1,1)-orgPos(1,4),orgPos(2,1)-orgPos(2,4)])/b1 - 1);
    wid = sqrt((c2*dep/d1)^2+dep^2);
end



% the new rectangle has the same width and height as the orginal one
adjPos = [orgPos(1,1), orgPos(1,1)+wid, orgPos(1,1)+wid, orgPos(1,1);
        orgPos(2,1), orgPos(2,1), orgPos(2,1)+hei, orgPos(2,1)+hei];

% compute homogramphy matrix adjPos = h * orgPos
[h, ~] = computeH(orgPos, adjPos);


% compute the adjusted image
t = projective2d(h);
adjIma = imwarp(orgIma, t);


end