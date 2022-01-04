function N = find_plane(lx,rx,ly,ry,K,x0)

options = optimoptions('fminunc');
options.Display = 'off';
options.MaxFunEvals = 800;
N = fminunc(@(N) cost(N,lx,rx,ly,ry,K),[x0(1) x0(2)],options);

end

function [cost] = cost(n,lx,rx,ly,ry,K)
N = [sin(n(1)) * cos(n(2));
    sin(n(1)) * sin(n(2));
    cos(n(1))];
cost = 0;
for i = 1:length(lx)
    ps = [lx(i); ly(i)];
    Ps = K\[ps;1];
    Qs = Ps-2*Ps'*N*N;
    qs = K*Qs./Qs(3,:);
    loss = intersection_loss(rx,ry,qs(1:2));
    cost = cost + loss;
end
end