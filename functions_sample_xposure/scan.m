clc; clear variables;
bi = 1;
c_scan = 1;

x_start = -2;
x_end = 2;
x_steps = 7;
x_apo = 0;
y_start = -3;
y_end = 3;
y_steps = 7;
y_apo = -3;

x = linspace(x_start,x_end,x_steps);
if x_apo>0
    x  = [x_apo x];
end

if bi==1
    xo = [x fliplr(x)];
    xl = length(xo)/2;
else
    xo = x;
    xl = length(x);
end

if c_scan == 1
    y = linspace(y_start,y_end,y_steps);
    for i=1:y_steps
        yh = linspace(y(i),y(i),xl);
        if i==1
            yo = yh;
            xo = x;
        elseif i>1
            yo = [yo, yh];
            if bi==0
                xo = [xo, x];
            elseif bi==1 && mod (i,2) == 1
                xo = [xo, x];
            elseif bi==1 && mod (i,2) == 0
                xo = [xo, fliplr(x)];
            end
        end
    end
else
    yo = linspace(y_start,y_start,length(xo));
end
if y_apo~=0
    yo = [yo y_apo];
    xo = [xo xo(1:length(y_apo))];
end

figure(1)
clf(1)
hold on
stairs(xo)
stairs(yo)