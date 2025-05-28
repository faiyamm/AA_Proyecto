function [colores_optimizados, hist_acumulativos] = optimizacion(imagenes_procesadas, histogramas)
%paso 4: función para optimizar histogramas acumulativos

num_imagenes = length(imagenes_procesadas);
colores_optimizados = zeros(num_imagenes, 1);

hist_acumulativos = containers.Map('KeyType', 'char', 'ValueType', 'any');
% crear un histograma acumulativo global
hist_acumulativo_global = zeros(size(histogramas{1}));
umbral_similitud = 0.9; % para considerar histogramas similares

for i = 1:num_imagenes
    % buscar histograma similar existente
    claves = keys(hist_acumulativos);
    encontrado = false;
    
    for k = 1:length(claves)
        hist_almacenado = hist_acumulativos(claves{k});
        correlacion = corrcoef(histogramas{i}, hist_almacenado);
        
        if correlacion(1,2) > umbral_similitud
            % usar el histograma existente
            [~, idx] = max(hist_almacenado);
            colores_optimizados(i) = (idx-1)/length(histogramas{i});
            encontrado = true;
            % Acumular histograma en el global
            hist_acumulativo_global = hist_acumulativo_global + histogramas{i};
            break;
        end
    end
    
    if ~encontrado
        % calcular y almacenar nuevo histograma
        hue = imagenes_procesadas{i}(:,:,1);
        hist_nuevo = histcounts(hue(:), linspace(0, 1, length(histogramas{i})+1));
        clave = ['hist_' num2str(i)];
        hist_acumulativos(clave) = hist_nuevo;
        
        % Acumular en el histograma global
        hist_acumulativo_global = hist_acumulativo_global + hist_nuevo;
        
        % determinar color dominante
        [~, idx] = max(hist_nuevo);
        colores_optimizados(i) = (idx-1)/length(hist_nuevo);
    end
end

% almacenar el histograma acumulativo global
hist_acumulativos('acumulativo_global') = hist_acumulativo_global;

disp('Optimización con histogramas acumulativos completada.');
end