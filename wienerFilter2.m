function y = wienerFilter2(x,r)
    
    ordem = 1000;
    
    % Autocorrelação do sinal de entrada
    Rxx = xcorr(x, x, 'biased');
    rk = Rxx(length(Rxx)/2:length(Rxx)); %matriz simétrica 
       
    % Matrize de Autocorrelacao
    MRx = rk(1:ordem);
    MRx = toeplitz(MRx);

   var_ruido = var(r);
   var_impulso = [var_ruido zeros(1,ordem-1)]';

   M2 = rk(1:ordem) - var_impulso;
   W = MRx\M2;
   disp(size(W))
    
   % Sinal filtrado
   y = filter(W, 1, x);
end
