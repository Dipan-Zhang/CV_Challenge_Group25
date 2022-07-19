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
