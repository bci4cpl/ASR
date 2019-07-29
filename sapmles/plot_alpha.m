%colors = repmat([1,0,0,.3],64,1);

close all;
b = plot(blotb_b', 'b');
hold on
m = plotb';

for i=1:64
    r = plot(m(:,i), 'r');
    r.Color(4)=.1;
end

