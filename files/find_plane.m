function N = find_plane(x,y,slope,K,x0)

options = optimoptions('fminunc');
options.Display = 'off';
options.MaxFunEvals = 150;
N = fminunc(@(N) cost(N,x,y,K,slope),[x0(1) x0(2)],options);
% n = [cos(N(1))*sin(N(2));
%     sin(N(1));
%     cos(N(1))*cos(N(2))];

end

function cost = cost(n,x,y,K,slope)
N = [cos(n(1))*sin(n(2));
    sin(n(1));
    cos(n(1))*cos(n(2))];
cost = 0;
for i = [1:20, 21:4:190, 190:210]
    ps = [x(i); y(i)];
    Ps = K\[ps;1];
    Qs = Ps-2*Ps'*N*N;
    qs = K*Qs./Qs(3,:);
    loss = intersection_loss(x,y,ps,qs(1:2),slope);
    cost = cost + loss;
end
end