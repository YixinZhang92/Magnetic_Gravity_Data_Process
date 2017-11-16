%
% /gaia/home/chi/oldclass/geop7112/problem2/prob2.m  
% Shu-Chioung Chiu
% September 19,2003

% inverse problem for the gravity caused by a sphere for arbitary values of N, xi.rho, R, X0 and Z.
% weighted least square solution
% asume all the weight equals to 1
%
% N; numbers of measurements 
% xi: arbitary point along the x-axis
% rho: difference in the densities of the sphere and of the medium surrounding the sphere
% R: radius of sphere
% (X0,R): center of sphere
% Z: depth from surface; measured positive downwards
% Gi: the theoretical gravitational attraction at xi
% Gi=Gi(xi,rho,R.X0,Z)=4pi/3*((gama*rho*R^3*Z)/(Xi^2+Z^2)^3/2)
% pi: 3.14159
% gamma: gravitational constant; 6.6732*10^-11 m^3kg^-1sec^-2
% Xi = xi-X0
% wi : weight for measurement, g, at xi
% widgi = wi * sum of (aijyi)

clear all
clc

% rho (in cgs)  = 0.25gr/cm^3 
rho=0.25;

% the actual values for R, X0, Z in km
X = 1;
R = 2; 
Z = 3;

% N # of measurements
N = 25;

% gamma in m^3kg^-1sec^-2
gamma = 6.6732 ; 
pi = 3.14159;

% setup constraints for dX0, dR, and dZ
Xc = .005;
Rc = .005;
Zc = .005;
%sigmac = 0.005;

%test XI:
% DAMPING FACTOR
%landa1 = lamda^2;
%lamda1 = 100;
lamda1 = 0.0110;

% MAXIMUM OF ITERATION
maxit=100;

% INITIAL VALUES OF X0, R0 AND Z0
%test I
%X0=10.0;
%R0=5.0;
%Z0=10.0
%test II
X0=100.0;
R0=1.0;
Z0=1.0;
%test III
%X0=1.0;
%R0=5.0;
%Z0=1.0;


%setup all matrix 
A=zeros(N,3);
dg=zeros(N,1);
y=zeros(3,1);
w=zeros(N,1);
B=zeros(N,3);

%setup initial values
numit = 0;
totalit = 0;
k = 1;

% all unit weight function
%load w.text
% group error into 5 subsets and assign weight
% weight=1 most realible data
% weight=0.2 worst data

% compute xi ranging from -12 km to 12 km in step of 1 km
% g(k) are the 25 measurements
% g(k) in milligal (mgal) 
%G(k) = (4*pi/3) * (gamma*rho*R0^3*Z0) * (((x(k)-X0)^2 + Z0^2)^(-3/2))
%dg(k) =g(k) - G(k)
%sigma(k) = sqrt(dg'(k)*dg(k)/(N-3))

% linear problem in matrix form [a]y=dg and 
% will be solved by damped least square
% ( [A]^T[A] + lamda^2[I] ) * {y} = [A]^T * {dg} 
% {y} = [dX; dR; dZ]

%setup constants for the while loop
const = 4*pi*gamma*rho;

x = (-12:12);
for I=1:N
    g(I) = (4*pi/3) * (gamma*rho*R^3*Z) * (((x(I)-X)^2 + Z^2)^(-3/2));
end
save g1.dat -ascii g;

maxg = max (g);

%for i=1:1
% use state to control fixed random numbers
     rand('state',0);
     r=rand(25,1);
% make random numbers become positive and negative
     random=r-0.5;
maxr = max(abs(random(:,1)));
% max error = 10% of the max value of gravity 
ratio = (maxg*0.1) / abs(maxr);
ratio =abs(maxr)/(maxg*0.1) 
newran = ratio * random(:,1);
save newran.dat -ascii newran;
save r.dat -ascii r;

for I=1:N
    gg(I) = g(I) + newran(I);
end
save gg.dat -ascii gg;

% all unit weight function
%load w.text
% group error into 5 subsets and assign weight
% weight=1 most realible data
% weight=0.2 worst data
% define weight for error
load newran.dat;
for i=1:N
    er(i)= abs(newran(i))/g(i);
    if er(i) >= 0.08
       w(i) = 0.2;
       else
       if er(i) >=0.06 
          w(i) = 0.4;
%          w(i) = 1;
          else
          if er(i) >=0.04 
             w(i) = 0.6;
%             w(i) = 1;
             else          
             if er(i) >=0.02
                w(i) = 0.8;
%                w(i) = 1;
                else
%                w(i) = 1;
                w(i) = 1;
             end
          end
       end
    end
end
save er.dat -ascii er;
save weight.dat -ascii w;

%load gravity1.dat:
%x=gravity1(:,1);
%g=gravity1(:,2);

%load gravity2.dat:
%x=gravity2(:,1);
%g=gravity2(:,2);

while numit < maxit
      for I=1:N
         DGDX=const*R0^3*Z0*( x(I)-X0 )*( (x(I)-X0)^2+Z0^2 )^(-5/2);
         DGDR=const*R0^2*Z0*( (x(I)-X0)^2+Z0^2 )^(-3/2);
            a=((x(I)-X0)^2+Z0^2)^(-3/2);
            b=3*(Z0^2)*((x(I)-X0)^2+Z0^2)^(-5/2);
         DGDZ=(const/3)*R0^3*(a-b);
% setup matrix A
         A(I,1)=w(I)*DGDX;
         A(I,2)=w(I)*DGDR;
         A(I,3)=w(I)*DGDZ;
%         B(I,1)=DGDX;
%         B(I,2)=DGDR;
%         B(I,3)=DGDZ;

% setup vector dg
         G(I) = (4*pi/3) * (gamma*rho*R0^3*Z0) * (((x(I)-X0)^2 + Z0^2)^(-3/2));
         dg(I) =gg(I) - G(I);
         dg(I) = w(I) * dg(I);
         end 

% 1st residual as k = 1
         sigma(k) = sqrt(dg'*dg/(N-3));

%Determine y = (dX,dR,dZ)
%Equation (8)
         y = inv(A'*A+lamda1*eye(3))*(A'*dg);

% check with criteria
         k = k+1;
               X0 = X0 + y(1,1);
               R0 = R0 + y(2,1);
               Z0 = Z0 + y(3,1);
               for I=1:N
                   G(I) = (4*pi/3) * (gamma*rho*R0^3*Z0) * (((x(I)-X0)^2 + Z0^2)^(-3/2));
                   dg(I) = gg(I) - G(I);
                   dg(I) = w(I) * dg(I);
               end
         sigma(k) = sqrt(dg'*dg/(N-3));

% check sigma and change lamda1
            if sigma(k) < sigma(k-1)
               lamda1 = lamda1/2;
            else
               lamda1 = lamda1*2;
               X0 = X0 - y(1,1);
               R0 = R0 - y(2,1);
               Z0 = Z0 - y(3,1);
            end

% check abs(y(1.1) wrt Xc, abs(y(2,1)) wrt Rc, abs(y(3,1)) wrt Zc
        if abs(y(1,1)) < Xc
           if abs(y(2,1)) < Rc
              if abs(y(3,1)) < Zc
                 numit = maxit;
              else
              end
           else
           end
        else
        end

        numit = numit + 1;
        totalit = totalit + 1;

end  %end while loop

save dg.mat -ascii dg;
save sigma.mat -ascii sigma;

% theoretical gravity corresponding to the inversion result
xx=-12:0.005:12;
for i=1:length(xx)
    G(i) =  (4*pi/3) * (gamma*rho*R0^3*Z0) * (((xx(i)-X0)^2 + Z0^2)^(-3/2));
% true location
    GG(i) =  (4*pi/3) * (gamma*rho*2^3*3) * (((xx(i)-1)^2 + 3^2)^(-3/2));
end

%print total interations and final Xo,Ro,Zo
    totalit
    X0
    R0
    Z0
    lamda1
%    y(1,1);
%    y(2,1);
%    y(3,1);
%    sigma
%    dg

% plot G(k) versus xi(k)
plot(xx,GG,'b-',xx,G,'r-',x,gg,'k*');
title('Figure 3.3 GRAVITY PLOT')
ylabel('gravity (mgal)')
xlabel('distance (km)')
%text(-12,3.8,'all weight = 1')
text(-12,3.4,'inversion resuls:');
text(-12,3,'rho = 0.25 g / cc');
text(-12,2.6,'X = 0.9020 km');
text(-12,2.2,'R = 1.9897 km');
text(-12,1.8,'Z = 2.9389 km');
text(-12,6,'blue curve: true location');
text(-12,5.6,'red curve: inversion location');
text(-12,5.2,'black *: measurement data');
text(7.5,3.4,'initial location:');
text(7.5,3,'rho = 0.25 g / cc');
text(7.5,2.6,'X = 100.0 km');
text(7.5,2.2,'R =   1.0 km');
text(7.5,1.8,'Z =   1.0 km');
