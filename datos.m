%-------------------------Datos del sistema--------------------------------

%Perfil de carga
time = xlsread('C:\Users\Yoan M\Desktop\COVID19\Davel\Softwares\Despacho de demanda\Datos para el despacho de demanda.xls','Datos','b3:y3');
power = xlsread('C:\Users\Yoan M\Desktop\COVID19\Davel\Softwares\Despacho de demanda\Datos para el despacho de demanda.xls','Datos','b4:y4');

%Datos ambientales
data = xlsread('C:\Users\Yoan M\Desktop\COVID19\Davel\Softwares\Despacho de demanda\Datos para el despacho de demanda.xls','Datos','b7:y9');

%Datos de las unidades generadoras
unit = xlsread('C:\Users\Yoan M\Desktop\COVID19\Davel\Softwares\Despacho de demanda\Datos para el despacho de demanda.xls','Datos','b12:f24');

a = -6.3;                               %Constantes de los aerogeneradores (Vesta V52-850kW)
b = 235;
c = -881.3;

d = 378.5;                              %Constantes de los grupos electrógenos
e = -4.1523;
f = 0.0239;
g = 0.00002;

Gstc = 1000;                            %Constantes de los paneles fotovoltaicos (DSM 250)
Tr = 25;
k = -0.43/100;

%-------------------------Preprocesamiento de datos------------------------
net = preprocess(time,power,data,unit,a,b,c,d,e,f,g,Gstc,Tr,k);          
