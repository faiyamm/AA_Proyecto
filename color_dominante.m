function [colores_dominantes, histogramas, indices_orden] = color_dominante(imagenes_procesadas)
%paso 2: functión para determinar el color dominante de las imágenes procesadas

num_imagenes = length(imagenes_procesadas);
colores_dominantes = zeros(num_imagenes, 1);
histogramas = cell(num_imagenes, 1);
num_bins = 64; % número de divisiones para el histograma

for i = 1:num_imagenes
    % extraer componente Hue
    hue = imagenes_procesadas{i}(:,:,1);
    
    % calcular histograma
    histograma = histcounts(hue(:), linspace(0, 1, num_bins+1));
    histogramas{i} = histograma;

    if max(histograma) == histograma(1) && sum(histograma > 0) < 3
        colores_dominantes(i) = NaN;
    else
        % encontrar pico (color dominante)
        [~, idx] = max(histograma);
        colores_dominantes(i) = (idx-1)/num_bins;
    end
    
    % mostrar progreso
    fprintf('Color dominante imagen %d: %.2f\n', i, colores_dominantes(i));
end

% ordenar las imágenes por color dominante
[colores_ordenados, indices_orden] = sort(colores_dominantes);

disp('Color dominante calculado para todas las imágenes.');
end