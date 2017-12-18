function [xx,GG,G,x,gg] = prob2_sub(profile_path, rho, X0,R0,Z0)
% PROB2_SUB Shu-Chioung Chiu's prob2.m program converted into a subroutine
% profile_path - specify path to the profile you want to invert
% rho - density of the sphere, used as constants for the while loop
% X0,R0,Z0 - initial location, radius and depth,
%          - these could affect your inversion results

%% Initialize parameters.

% clear previous output
delete('./output/*');

% read input data
eliz_p = load(profile_path);
x = eliz_p(:,1);
g = eliz_p(:,2);
N = length(g);

% setup domain of study
xmin = min(x);
xmax = max(x);

% rho (in cgs)  = 0.25gr/cm^3 
% rho=0.25;  % used for computing G(I) and GG(i)
% it only affect profile of the true location according to my test

% the actual values for R, X0, Z in km
% X = 1;  % note by Yu Geng:
% R = 2;  % used for computing g(I) and GG(i)
% Z = 3;  % we do not need them when using Elizabeth's profiles

% N # of measurements
% N = 25;  % we get N from the size of input data instead

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

%% Observed values.

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

% x = (-12:12);
% for I=1:N
%     g(I) = (4*pi/3) * (gamma*rho*R^3*Z) * (((x(I)-X)^2 + Z^2)^(-3/2));
% end
% when using elizabeth's profiles, x and g can be obtained from input data
% read documentation above
save ./output/g1.dat -ascii g;

maxg = max (g);

%for i=1:1
% use state to control fixed random numbers
     rand('state',0);
     r=rand(N,1);
% make random numbers become positive and negative
     random=r-0.5;
maxr = max(abs(random(:,1)));
% max error = 10% of the max value of gravity 
%ratio = (maxg*0.1) / abs(maxr);
ratio = abs(maxr)/(maxg*0.1);
newran = ratio * random(:,1);
save ./output/newran.dat -ascii newran;
save ./output/r.dat -ascii r;

for I=1:N
    gg(I) = g(I) + newran(I);
end
save ./output/gg.dat -ascii gg;

%% New assign weights.

% all unit weight function
%load w.text
% group error into 5 subsets and assign weight
% weight=1 most realible data
% weight=0.2 worst data
% define weight for error
load ./output/newran.dat;
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
save ./output/er.dat -ascii er;
save ./output/weight.dat -ascii w;

%load gravity1.dat:
%x=gravity1(:,1);
%g=gravity1(:,2);

%load gravity2.dat:
%x=gravity2(:,1);
%g=gravity2(:,2);

%% Beginning of the iteration.

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

save ./output/dg.mat -ascii dg;
save ./output/sigma.mat -ascii sigma;

%% Output data.

% theoretical gravity corresponding to the inversion result
xx=xmin:0.005:xmax;
for i=1:length(xx)
    G(i) = (4*pi/3) * (gamma*rho*R0^3*Z0) * (((xx(i)-X0)^2 + Z0^2)^(-3/2));  % inversion location
    % GG(i) = (4*pi/3) * (gamma*rho*R^3*3) * (((xx(i)-X)^2 + Z^2)^(-3/2));  % true location
end

% when using elizabeth's profiles, GG(i) should be computed this way
GG = interpn(x, g, xx, 'pchip');

% %print total interations and final Xo,Ro,Zo
disp(['Total # of iterations: ', num2str(totalit)]);
disp(['Final location (X, R, Z) [km]: ', num2str(X0), ...
    '  ', num2str(R0), '  ', num2str(Z0)]);

end
