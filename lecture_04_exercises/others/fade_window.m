N = 1000;
n = (0:N-1);
nn = (0:2*N-1);

eq1 = 0.5*(1 - cos(pi * n/(N-1)));
eq2 = 0.5*(1 + cos(pi * n/(N-1)));
eq3 = 0.5*(1 - cos(2 * pi * nn/(2*N-1)));
eq = 0.5*(1 - cos(2 * pi * n/(N-1)));

h = hann( 2* 1000);

figure(1);
plot(eq1);
hold on;
plot(eq3(1:N), '*');
plot(h(1:N), 'o');
plot(eq(1:N/2), 'LineStyle',':');
legend('middle equation', 'complete equation', 'window');
hold off

figure(2)
plot(eq2);
hold on;
plot(eq3(N+1:end), '*');
plot(h(N+1:end), 'o');
plot(eq(N/2+1:end), ':');
legend('middle equation', 'complete equation', 'window');
hold off

figure(3);
plot(eq3);

figure(4);
plot(h);


