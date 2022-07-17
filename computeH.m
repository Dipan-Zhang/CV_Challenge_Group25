function [h, t] = computeH(s, d)
% s and d are 2xN matrices, you want to compute a homography which
% takes the source points to destination points.
% h is the homography matrix and t is the tform returned from the
% maketfrom function
s = [s(:,1:4); ones(1,4)];
d = [d(:,1:4); ones(1,4)];

%% SVD
A = [kron(s(:,1),x_hat(d(:,1)))';
    kron(s(:,2),x_hat(d(:,2)))';
    kron(s(:,3),x_hat(d(:,3)))';
    kron(s(:,4),x_hat(d(:,4)))'];
[~,~,V] = svd(A);
H = reshape(V(:,end),[3,3])';
[~,sigma,~] = svd(H);
h = H/H(3,3);

%% Use maketform to generate a transformation that will construct a projective
% transform by providing a H matrix.
t = maketform ('projective', h);
end
% 
% function [h, t] = computeH(s, d)
%     % s and d are 2xN matrices, you want to compute a homography which
%     % takes the source points to destination points.
%     % h is the homography matrix and t is the tform returned from the
%     % maketfrom function
%     s = [s(:,1:4); ones(1,4)];
%     d = [d(:,1:4); ones(1,4)];
%     %% Write code to set up a system of equations solving which will give 
%     % you the homography.
%     h_33 = 1;
%     
%     syms h_11 h_12 h_13 h_21 h_22 h_23 h_31 h_32
%     
%     [a,b,c,d,e,f,g,i] = ...
%     solve((h_11*s(1,1)+h_12*s(2,1)+h_13*s(3,1))/(h_31*s(1,1)+h_32*s(2,1)+h_33*s(3,1)) - d(1,1),...
%           (h_11*s(1,2)+h_12*s(2,2)+h_13*s(3,2))/(h_31*s(1,2)+h_32*s(2,2)+h_33*s(3,2)) - d(1,2),...
%           (h_11*s(1,3)+h_12*s(2,3)+h_13*s(3,3))/(h_31*s(1,3)+h_32*s(2,3)+h_33*s(3,3)) - d(1,3),...
%           (h_11*s(1,4)+h_12*s(2,4)+h_13*s(3,4))/(h_31*s(1,4)+h_32*s(2,4)+h_33*s(3,4)) - d(1,4),...
%           (h_21*s(1,1)+h_22*s(2,1)+h_23*s(3,1))/(h_31*s(1,1)+h_32*s(2,1)+h_33*s(3,1)) - d(2,1),...
%           (h_21*s(1,2)+h_22*s(2,2)+h_23*s(3,2))/(h_31*s(1,2)+h_32*s(2,2)+h_33*s(3,2)) - d(2,2),...
%           (h_21*s(1,3)+h_22*s(2,3)+h_23*s(3,3))/(h_31*s(1,3)+h_32*s(2,3)+h_33*s(3,3)) - d(2,3),...
%           (h_21*s(1,4)+h_22*s(2,4)+h_23*s(3,4))/(h_31*s(1,4)+h_32*s(2,4)+h_33*s(3,4)) - d(2,4));
%                 
%     h = double([a,b,c; d,e,f; g,i,1])
%     %% Use maketform to generate a transformation that imtransform will 
%     % understand.
%     
%     t = maketform ('projective', h');
% end