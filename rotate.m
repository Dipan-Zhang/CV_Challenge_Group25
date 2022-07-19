function adjIm = rotate(im)
% rotate the orignal image according to a user defined horizontal line

while 1
  
  % get the vanishing point
  [x,y,button] = ginput(2);

  % if pressed ENTER, quit the loop
  if (isempty(button))
    break;
  end
  points = [x';y'];
  % draw
  imshow(im);
  hold on;

  plot(points(1,:), points(2,:),"Color",'r','LineWidth',2);
  hold off;
  drawnow;
end

direction = [points(1,1)-points(2,1);points(2,1)-points(2,2)];
theta = atan(direction(2)/direction(1));
theta = theta * 180 / pi;
adjIm = imrotate(im,theta);

end