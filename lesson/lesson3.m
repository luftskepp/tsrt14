%%%%%%%%%
%% init
% initcourse('TSRT14');
addpath ../sftoolbox/mfiles/ ../sftoolbox/data/ ../sftoolbox/classes/;
%%%%%%%%%

%% 2.10
% init network
sm = exsensor('gps2d',2,1);
sm.x0 = [1 2];
sm.pe = 0.01*eye(4);
% show network
figure(1); plot(sm); title 'target pos';
sm
% simulate:
y = simulate(sm,1);
figure(2); lh2(sm,y);
% estimate:
[xls,sls] = ls(sm,y);
[xwls,swls] = wls(sm,y);
figure(3);plot(sm,sls,swls); legend 'sm' 'ls' 'swls';

figure(4); xplot2(xls,xwls,'conf',90); legend 'ls' 'wls';

%% 3.10
sm = exsensor('toa',4);
sm.x0 = [1 2];
sm.th = 3*rand(size(sm.th));
pe = 0.01*eye(4); pe(1)=pe(1)+1;
sm.pe = pe;
figure(1); plot(sm); title 'sensor ntwork';
% eval:
y = simulate(sm,1);
figure(2); lh2(sm,y);
% estimate:
xls = ls(sm,y); xwls = wls(sm,y);
xnls = estimate(sm,y);
figure(3); xplot2(xls,xwls,'conf',90); hold on;
crlb(sm,y); legend xls xwls crlb;

%% 3.7
a = 1; b=-2;c =3;
N = 1000;
n = (1:N)';
y = a + b*log(c + n);
chat = 0:0.01:5;
ahat = zeros(size(chat));
bhat = zeros(size(chat));
V = zeros(size(chat));
for i=1:length(chat)
    H = [ones(N,1) log((1:N)' + chat(i))];
    tmp = H\y;
    ahat(i) = tmp(1);
    bhat(i) = tmp(2);
    yhat = ahat(i) + bhat(i)*log((1:N)' + chat(i));
    V(i) = sum((y-yhat).^2);    
end

[~, ind] = min(V);
a1 = ahat(ind)
b1 = bhat(ind)
c1 = chat(ind)

%% 4.7
X = ndist([1;1],eye(2));
h = @(x)[x(1,:).*x(2,:) ; x(1,:)./x(2,:)];
Ytt1 = tt1eval(X,h);
Ytt2 = tt2eval(X,h);
Yut = uteval(X,h);
Ymc = mceval(X,h);
plot2(Ytt1,Ytt2,Yut,Ymc,'legend',{'auto'},'col','bgrk')
%legend tt1 tt1 tt2 tt2 ut ut mc mc;

%% 4.8
h = '[x(1,:).*x(2,:) ; x(1,:)./x(2,:)]';

sm = sensormod(h,[2,0,2,0]);
sm.x0 = [1 1];
sm.pe = ndist( [0 ; 0], [.1 .05 ; .05 .3]);

y = simulate(sm,10);

xls = ls(sm,y);
xwls = wls(sm,y);

xplot2(xls,xwls,'conf',90)


%% 4.9
s = exsensor('TOA', 8);
s.x0 = [0 ; 0];
s.th = [ 1 1 , 1 0 , 1 -1 , 0 -1 , -1 -1 , -1 0 , -1 1 , 0 1 ];
s.pe = ndist(zeros(8,1),diag(5*rand(8,1)));
y = simulate(s,1);
xls = ls(s,y);
xwls = wls(s,y);
xplot2(xls,xwls,'conf',90); hold on; crlb(s); hold off;
figure; plot(s); hold on;crlb2(s,y);

%% 5.4
N = 10000;
X = ndist(0 , 0.1);
