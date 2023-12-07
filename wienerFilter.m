function y = wienerFilter(x, sd, order)
    % Função para aplicar o filtro de Wiener conhecendo-se o sinal desejado
    
    %Autocorrelação do sinal de entrada
    Rxx = xcorr(x, x, 'biased');
    Rx = Rxx(length(Rxx)/2:length(Rxx)); 
    
    %Intercorrelação do sinal de entrada com o desejado

    Rdxx = xcorr(sd, x, 'biased');
    Rdx = Rdxx(length(Rdxx)/2:length(Rdxx))';
    
    % Matrizes de Autocorrelacao
    MRx = Rx(1:order);
    MRx = toeplitz(MRx);
    MRdx = Rdx(1:order);

    W = MRx\MRdx;
    
    
    % Sinal filtrado
    y = filter(W, 1, x);
end
