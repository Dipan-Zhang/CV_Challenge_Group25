function gbim = filtered(im, x, y)
% make the selected area of foreground blurred
 A(:,:,1) = im(x(1):x(2),y(1):y(2),1);
 A(:,:,2) = im(x(1):x(2),y(1):y(2),2);
 A(:,:,3) = im(x(1):x(2),y(1):y(2),3);
 m=imgaussfilt(A,2);

 gbim = im;
 gbim(x(1):x(2),y(1):y(2),:) = m;

%  figure;  imshow(gbim);  title('after blurring');
%  imwrite(gbim, 'after blurring.jpg');