function net = preprocess(time,power,data,unit,a,b,c,d,e,f,g,Gstc,Tr,k)
%-------------------------------Datos--------------------------------------

ntime = length(time);       %Estados de carga
Pmin = unit(:,1);           %Potencia minima de las unidades
Pmax = unit(:,2);           %Potencia maxima de las unidades
keo = unit(:,3);            %Costo especifico de mantenimiento
Me = unit(:,4);             %Nivel de las emisiones
kee = unit(:,5);            %Costo especifico de las emisiones
nunit = length(Pmin);       %Numero de unidades
V = data(1,:);              %Velocidad del viento
Ging = data(2,:);           %Irradiancia incidente
Tc = data(3,:);             %Temparatura de la celda

%--------------------------------------------------------------------------

net.time = time;
net.power = power;
net.ntime = ntime;
net.Pmin = Pmin;
net.Pmax = Pmax;
net.keo = keo;
net.Me = Me;
net.kee = kee;
net.nunit = nunit;
net.V = V;
net.Ging = Ging;
net.Tc = Tc;
net.a = a;
net.b = b;
net.c = c;
net.d = d;
net.e = e;
net.f = f;
net.g = g;
net.Gstc = Gstc;
net.Tr = Tr;
net.k = k;

