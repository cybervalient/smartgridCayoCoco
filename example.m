clear all
datos;
%-----------------------------Parámetros de la red-------------------------
time = net.time;
power = net.power;
ntime = net.ntime;
Pmin = net.Pmin;
Pmax = net.Pmax;
keo = net.keo;
Me = net.Me;
kee = net.kee;
nunit = net.nunit;
V = net.V;
Ging = net.Ging;
Tc = net.Tc;
a = net.a;
b = net.b;
c = net.c;
Gstc = net.Gstc;
Tr = net.Tr;
k = net.k;

%---------------------Algortimo genético y conteo de tiempo----------------
nvars = nunit*ntime;

Aeq = eye(ntime);                       %Matriz Aeq de balance de potencia
for i = 2:nunit
    Aeqo = eye(ntime);
    Aeq = [Aeq Aeqo];
end
beq = power';                           %Vector beq de balance de potencia


LB = zeros(nvars,1);                    %Restricciones de potencia de las unidades convencionales (fuel y diesel)
UB = Pmax(1)*ones(ntime,1);
for i = 2:(nunit-3),
    UBo = Pmax(i)*ones(ntime,1);
    UB = [UB UBo];
end

Pmaxfuel=sum(Pmax(1:5,:));

for i = 6:(nunit-3),
    for j = 1:ntime,
        if Pmaxfuel >= power(j),
            UB(j,i) = 0.01;
        end
    end
end    
        
UB = [UB(:,1);UB(:,2);UB(:,3);UB(:,4);UB(:,5);UB(:,6);UB(:,7);UB(:,8);UB(:,9);UB(:,10)];

for j = 1:ntime,                        %Potencia de salida del parque fotovoltaico
    Pw(j) = (a * (V(j)^2)) + (b * V(j)) + c;
end
UB = [UB;Pw'];

for j = 1:ntime,                        %Potencia de salida del parque fotovoltaico
    Pw(j) = (a * (V(j)^2)) + (b * V(j)) + c;
end
UB = [UB;Pw'];

for j = 1:ntime,                        %Potencia de salida del parque solar
    Pfv(j) = Pmax(13) * Ging(j) / Gstc * (1 + k * (Tc(j) - Tr));
end
UB = [UB;Pfv'];

tic 
%options = gaoptimset('PopulationSize',50,'Generations',100,'StallTimeLimit',Inf);
%[x,fval,reason,output] = ga(@(x) objfunc(x,net),nvars,[],[],Aeq,beq,LB,UB,[],options);
[x,fmin] = edaC(net,[],[],0,Aeq,beq,length(beq),LB,UB,nvars,50,100);

minutes = toc/60;

%--------------------------Función objetivo -------------------------------

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

Ko = sum((keo' * x));
Ke = sum(((kee.* Me)' * x));

% Edición de los resultados finales
xlswrite('C:\Users\Yoan M\Desktop\COVID19\Davel\Softwares\Despacho de demanda\Datos para el despacho de demanda.xls',round(x),'Resultados','b3:y15');
disp('La potencia horaria a generar por cada unidad esta en el fichero: Datos para el despacho de demanda.xls en la hoja de calculo Resultados');
disp('Costo del combustible, en pesos por día');
disp(Kg);
disp('Costo de explotación, en pesos por día');
disp(Ko);
disp('Costo de las emisiones, en pesos por día');
disp(Ke);
disp('Costo total de la generacion, en pesos por día');
disp(costo);
disp('Tiempo de optimización, en minutos:');
disp(minutes);

