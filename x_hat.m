function m = x_hat(x)
% change vetor into a 3x3 matrix
% input:    x: a 1x3 vector
% output:   m: a 3x3 matrix
m = [0    -x(3)  x(2);
     x(3)  0    -x(1);
    -x(2)  x(1)  0];
end