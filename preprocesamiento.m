function [imagenes_procesadas, archivos] = preprocesamiento()
%paso 1: función para preprocesar las imágenes

carpeta_imagenes = 'img/';
archivos = dir([carpeta_imagenes '*.png']);
num_imagenes = length(archivos);
imagenes_procesadas = cell(num_imagenes, 1);
tam_estandar = [256, 256]; % tamaño estándar para redimensionar las imágenes

% procesar cada imagen
for i = 1:num_imagenes
    % leer imagen
    img_original = imread([carpeta_imagenes archivos(i).name]);
    
    % redimensionar
    img_redim = imresize(img_original, tam_estandar);
    
    % convertir a HSV
    img_hsv = rgb2hsv(img_redim);
    
    % almacenar
    imagenes_procesadas{i} = img_hsv;
    
    % mostrar progreso
    fprintf('Imagen %d/%d procesada: %s\n', i, num_imagenes, archivos(i).name);
end

disp('Preprocesamiento completado.');
end