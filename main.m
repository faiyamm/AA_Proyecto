clc; clear; close all;
% paso 1: script principal que ejecuta todo el flujo de trabajo

% cargar y preprocesar las imágenes
[imagenes_procesadas, archivos] = preprocesamiento();

% determinar el color dominante de las imágenes
[colores_dominantes, histogramas, indices_orden] = color_dominante(imagenes_procesadas);

% crear un grafo de similitud entre las imágenes
umbral_similitud = 0.15; % se puede ajustar
[grupos, matriz_adyacencia] = grafo_similitud(colores_dominantes, umbral_similitud);

%optimizar con histogramas acumulativos
[colores_optimizados, hist_acumulativos] = optimizacion(imagenes_procesadas, histogramas);

% visualizar los resultados
visualizacion(imagenes_procesadas, indices_orden, grupos, archivos);