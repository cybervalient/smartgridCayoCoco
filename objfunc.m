function result = objfunc(x,net)
objective   = 0;

%-----------------------------Parámetros de la red-------------------------

nunit = net.nunit;
ntime = net.ntime;
keo = net.keo;
Me = net.Me;
kee = net.kee;
Pmax = net.Pmax;
d = net.d;
e = net.e;
f = net.f;
g = net.g;

%--------------------------Función objetivo -------------------------------\

i = 1;                                  %Vector decimal a matriz decimal
for j = 1:nunit,
    for u = 1:ntime,
        y(j,u) = x(i);
        i = i + 1;
    end
end
x = y;

for u = 1:(ntime),
    for j = 1:(nunit-3),
    Kg(j,u) = (d + (e * x(j,u) * 100 / Pmax(j)) + (f * (x(j,u) * 100 / Pmax(j))^2)*x(j,u)*g);
    end
end

Kg = sum(sum(Kg));

costo = Kg + sum((keo' * x) + ((kee.* Me)' * x));
%costo = sum((keg' * x) + (keo' * x) + ((kee.* Me)' * x));  

result = costo;
end

