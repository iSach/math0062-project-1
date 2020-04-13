population = 'RRRRRRNNNB';
population = population(:);
blue = 0;
red = 0;
black = 0;
size = 10000000;
for i=1:size
   k = randsample(population, 1);
   switch(k)
       case 'R'
           red = red + 1;
       case 'B'
           blue = blue + 1;
       case 'N'
           black = black + 1;
   end
end
disp(red / size);
disp(black / size);
disp(blue / size);