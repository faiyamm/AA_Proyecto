function [imagenes_procesadas, archivos] = preprocesamiento()
    carpeta_imagenes = 'img/';
    archivos = dir([carpeta_imagenes '*.png']);
    num_imagenes = length(archivos);
    imagenes_procesadas = cell(num_imagenes, 1);
    tam_estandar = [256, 256]; % tamaño estándar para redimensionar las imágenes

    for i = 1:num_imagenes
        img_original = imread([carpeta_imagenes archivos(i).name]);
        img_redim = imresize(img_original, tam_estandar);
        img_hsv = rgb2hsv(img_redim);
        imagenes_procesadas{i} = img_hsv;

        % mostrar histograma hsv por cada imagen
        figure;
        subplot(2,2,1);
        imshow(img_hsv);
        xlabel('Imagen HSV');
        subplot(2,2,2);
        imhist(img_hsv(:,:,1));
        xlabel('Canal Hue');
        subplot(2,2,3);
        imhist(img_hsv(:,:,2));
        xlabel('Canal Saturation');
        subplot(2,2,4);
        imhist(img_hsv(:,:,3));
        xlabel('Canal Value');

        fprintf('Imagen %d/%d procesada: %s\n', i, num_imagenes, archivos(i).name);
    end
    disp('Preprocesamiento completado.');
end